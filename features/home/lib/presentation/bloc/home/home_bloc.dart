import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:home/domain/entity/jadwal_harian_entity.dart';
import 'package:home/domain/usecase/home_usecase.dart';
import 'package:home/presentation/bloc/home/home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeUsecase homeUsecase;
  final FlutterLocalNotificationsPlugin notificationsPlugin;
  Timer? _timer;
  String? _lastAzanShown;

  HomeBloc({required this.homeUsecase, required this.notificationsPlugin})
    : super(const HomeState(loading: true)) {
    on<GetIdCity>(_getIdCity);
    on<UpdateCurrentTime>(_onUpdateCurrentTime);
    on<ShowAzanDialog>(_onShowAzanDialog);

    // Timer untuk update jam real-time
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(UpdateCurrentTime());
    });
  }

  // =========================
  // 🔹 Fetch Jadwal Salat
  // =========================
  Future<void> _getIdCity(GetIdCity event, Emitter<HomeState> emit) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final response = await homeUsecase.getJadwalHarian(event.city);
      emit(
        state.copyWith(
          city: event.city,
          loading: false,
          jadwalHarian: response,
        ),
      );
      await _jadwalkanNotifikasiAzan(response);
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }

  // =========================
  // 🔹 Update waktu aktif
  // =========================
  void _onUpdateCurrentTime(UpdateCurrentTime event, Emitter<HomeState> emit) {
    final now = DateTime.now();
    final aktif = _tentukanWaktuSalatAktif(now, state.jadwalHarian);
    final next = _tentukanWaktuSalatBerikutnya(now, state.jadwalHarian);

    // Jika waktu salat baru aktif, tampilkan azan
    if (aktif != null && aktif != _lastAzanShown) {
      _lastAzanShown = aktif;
      add(ShowAzanDialog(aktif));
      _showNotificationAzan(aktif);
    }

    emit(
      state.copyWith(
        currentTime: now,
        waktuAktif: aktif,
        waktuSalatBerikutnya: next['nama'],
        countdown: next['countdown'],
      ),
    );
  }

  void _onShowAzanDialog(ShowAzanDialog event, Emitter<HomeState> emit) {
    emit(state.copyWith(showAzanDialog: event.prayerName));
  }

  // =========================
  // 🔹 Notifikasi Azan
  // =========================
  String _getAzanSound(String prayerName) {
    return prayerName.toLowerCase() == 'subuh' ? 'azan_subuh' : 'azan_normal';
  }

  Future<void> _showNotificationAzan(String prayerName) async {
    final androidDetails = AndroidNotificationDetails(
      'azan_channel_v2',
      'Azan Notifications',
      channelDescription: 'Pengingat waktu salat',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(_getAzanSound(prayerName)),
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
    );

    await notificationsPlugin.show(
      prayerName.hashCode,
      'Waktu $prayerName Telah Tiba',
      'Sudah masuk waktu salat $prayerName, yuk segera salat 🙏',
      NotificationDetails(android: androidDetails),
    );
  }

  // =========================
  // 🔹 Hitung waktu aktif & berikutnya
  // =========================
  String? _tentukanWaktuSalatAktif(DateTime now, JadwalHarianEntity? jadwal) {
    if (jadwal == null) return null;

    DateTime parse(String w) {
      final p = w.split(':');
      return DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(p[0]),
        int.parse(p[1]),
      );
    }

    final times = {
      'Imsak': parse(jadwal.imsak ?? '04:30'),
      'Subuh': parse(jadwal.subuh ?? '04:45'),
      'Dhuha': parse(jadwal.dhuha ?? '06:15'),
      'Dzuhur': parse(jadwal.dzuhur ?? '12:00'),
      'Ashar': parse(jadwal.ashar ?? '15:30'),
      'Maghrib': parse(jadwal.maghrib ?? '18:00'),
      'Isya': parse(jadwal.isya ?? '19:15'),
    };

    String? aktif;
    for (final entry in times.entries) {
      if (now.isAfter(entry.value)) aktif = entry.key;
    }
    return aktif;
  }

  Map<String, dynamic> _tentukanWaktuSalatBerikutnya(
    DateTime now,
    JadwalHarianEntity? jadwal,
  ) {
    if (jadwal == null) return {'nama': null, 'countdown': '--:--:--'};

    DateTime parse(String w) {
      final p = w.split(':');
      return DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(p[0]),
        int.parse(p[1]),
      );
    }

    final list = [
      {'nama': 'Imsak', 'waktu': parse(jadwal.imsak ?? '04:30')},
      {'nama': 'Subuh', 'waktu': parse(jadwal.subuh ?? '04:45')},
      {'nama': 'Dhuha', 'waktu': parse(jadwal.dhuha ?? '06:15')},
      {'nama': 'Dzuhur', 'waktu': parse(jadwal.dzuhur ?? '12:00')},
      {'nama': 'Ashar', 'waktu': parse(jadwal.ashar ?? '15:30')},
      {'nama': 'Maghrib', 'waktu': parse(jadwal.maghrib ?? '18:00')},
      {'nama': 'Isya', 'waktu': parse(jadwal.isya ?? '19:15')},
    ];

    for (final i in list) {
      if ((i['waktu'] as DateTime).isAfter(now)) {
        final diff = (i['waktu'] as DateTime).difference(now);
        return {'nama': i['nama'], 'countdown': _formatDuration(diff)};
      }
    }

    final diff = (list.first['waktu'] as DateTime).difference(
      now.add(const Duration(days: -1)),
    );
    return {'nama': list.first['nama'], 'countdown': _formatDuration(diff)};
  }

  String _formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.inHours)}:${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}';
  }

  Future<void> _jadwalkanNotifikasiAzan(JadwalHarianEntity jadwal) async {
    final prayers = {
      'Subuh': jadwal.subuh,
      'Dzuhur': jadwal.dzuhur,
      'Ashar': jadwal.ashar,
      'Maghrib': jadwal.maghrib,
      'Isya': jadwal.isya,
    };
    await notificationsPlugin.cancelAll();

    final now = DateTime.now();
    for (final e in prayers.entries) {
      if (e.value == null) continue;
      final p = e.value!.split(':');
      final jadwalWaktu = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(p[0]),
        int.parse(p[1]),
      );
      if (jadwalWaktu.isBefore(now)) continue;

      await notificationsPlugin.zonedSchedule(
        e.key.hashCode,
        'Waktu ${e.key}',
        'Sudah masuk waktu ${e.key}',
        tz.TZDateTime.from(jadwalWaktu, tz.local),
        NotificationDetails(
          android: AndroidNotificationDetails(
            'azan_channel_v2',
            'Azan Notifications',
            channelDescription: 'Pengingat waktu salat',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            sound: RawResourceAndroidNotificationSound(_getAzanSound(e.key)),
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
