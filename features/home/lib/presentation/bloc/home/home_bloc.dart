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
    // on<TestAzan>(_onTestAzan); // ✅ Event manual test azan

    // Update jam realtime setiap 1 detik
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(UpdateCurrentTime());
    });
  }

  /// 🔹 Ambil jadwal harian berdasarkan kota
  Future<void> _getIdCity(GetIdCity event, Emitter<HomeState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      final response = await homeUsecase.getJadwalHarian(event.city);

      emit(
        state.copyWith(
          city: event.city,
          loading: false,
          jadwalHarian: response,
        ),
      );

      // 🔔 Setelah jadwal salat didapat → jadwalkan notifikasi azan
      await _jadwalkanNotifikasiAzan(response);
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }

  /// 🔹 Update jam realtime dan countdown
  void _onUpdateCurrentTime(UpdateCurrentTime event, Emitter<HomeState> emit) {
    final now = DateTime.now();
    final waktuAktif = _tentukanWaktuSalatAktif(now, state.jadwalHarian);
    final nextPrayerInfo = _tentukanWaktuSalatBerikutnya(
      now,
      state.jadwalHarian,
    );

    // 🔔 Jika masuk waktu baru dan belum ditampilkan
    if (waktuAktif != null && waktuAktif != _lastAzanShown) {
      _lastAzanShown = waktuAktif;
      add(ShowAzanDialog(waktuAktif));
      _showNotificationAzan(waktuAktif); // tampilkan notifikasi segera
    }

    emit(
      state.copyWith(
        currentTime: now,
        waktuAktif: waktuAktif,
        waktuSalatBerikutnya: nextPrayerInfo['nama'],
        countdown: nextPrayerInfo['countdown'],
      ),
    );
  }

  /// 🔹 Event untuk menampilkan dialog azan di UI
  void _onShowAzanDialog(ShowAzanDialog event, Emitter<HomeState> emit) {
    emit(state.copyWith(showAzanDialog: event.prayerName));
  }

  /// 🔹 Event untuk test azan manual
  // Future<void> _onTestAzan(TestAzan event, Emitter<HomeState> emit) async {
  //   await _showNotificationAzan(event.prayerName);
  // }

  /// 🔹 Tampilkan notifikasi azan langsung
  Future<void> _showNotificationAzan(String prayerName) async {
    final soundFile =
        prayerName.toLowerCase() == 'subuh'
            ? 'azan_subuh'
            : 'azan_normal'; // tanpa .mp3

    const channelId = 'azan_channel_v2'; // ganti channel baru agar suara aktif

    final androidDetails = AndroidNotificationDetails(
      channelId,
      'Azan Notifications',
      channelDescription: 'Pemberitahuan waktu salat',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(soundFile),
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
    );

    final details = NotificationDetails(android: androidDetails);

    await notificationsPlugin.show(
      0,
      'Waktu $prayerName Telah Tiba',
      'Sudah masuk waktu salat $prayerName, yuk segera salat 🙏',
      details,
    );
  }

  /// 🔹 Tentukan waktu salat aktif
  String? _tentukanWaktuSalatAktif(DateTime now, JadwalHarianEntity? jadwal) {
    if (jadwal == null) return null;

    DateTime parse(String waktu) {
      final parts = waktu.split(':');
      return DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
    }

    final map = {
      'Imsak': parse(jadwal.imsak ?? '04:30'),
      'Subuh': parse(jadwal.subuh ?? '04:45'),
      'Dhuha': parse(jadwal.dhuha ?? '06:15'),
      'Dzuhur': parse(jadwal.dzuhur ?? '12:00'),
      'Ashar': parse(jadwal.ashar ?? '15:30'),
      'Maghrib': parse(jadwal.maghrib ?? '18:00'),
      'Isya': parse(jadwal.isya ?? '19:15'),
    };

    String? aktif;
    for (final entry in map.entries) {
      if (now.isAfter(entry.value)) aktif = entry.key;
    }
    return aktif;
  }

  /// 🔹 Tentukan waktu salat berikutnya dan countdown
  Map<String, dynamic> _tentukanWaktuSalatBerikutnya(
    DateTime now,
    JadwalHarianEntity? jadwal,
  ) {
    if (jadwal == null) return {'nama': null, 'countdown': '--:--:--'};

    DateTime parse(String waktu) {
      final parts = waktu.split(':');
      return DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
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

    for (final item in list) {
      if ((item['waktu'] as DateTime).isAfter(now)) {
        final diff = (item['waktu'] as DateTime).difference(now);
        return {'nama': item['nama'], 'countdown': _formatDuration(diff)};
      }
    }

    final besok = (list.first['waktu'] as DateTime).add(
      const Duration(days: 1),
    );
    final diff = besok.difference(now);
    return {'nama': list.first['nama'], 'countdown': _formatDuration(diff)};
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final h = twoDigits(d.inHours);
    final m = twoDigits(d.inMinutes.remainder(60));
    final s = twoDigits(d.inSeconds.remainder(60));
    return '$h:$m:$s';
  }

  /// 🔔 Jadwalkan notifikasi azan otomatis
  Future<void> _jadwalkanNotifikasiAzan(JadwalHarianEntity jadwal) async {
    final prayers = {
      'Subuh': jadwal.subuh,
      'Dzuhur': jadwal.dzuhur,
      'Ashar': jadwal.ashar,
      'Maghrib': jadwal.maghrib,
      'Isya': jadwal.isya,
    };

    await notificationsPlugin.cancelAll(); // bersihkan lama

    final now = DateTime.now();

    for (final entry in prayers.entries) {
      if (entry.value == null) continue;

      final parts = entry.value!.split(':');
      final jadwalWaktu = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );

      if (jadwalWaktu.isBefore(now)) continue;

      final soundFile =
          entry.key.toLowerCase() == 'subuh' ? 'azan_subuh' : 'azan';

      await notificationsPlugin.zonedSchedule(
        entry.key.hashCode,
        'Waktu ${entry.key}',
        'Sudah masuk waktu ${entry.key}',
        tz.TZDateTime.from(jadwalWaktu, tz.local),
        NotificationDetails(
          android: AndroidNotificationDetails(
            'azan_channel',
            'Azan Notifications',
            channelDescription: 'Notifikasi pengingat waktu salat',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            sound: RawResourceAndroidNotificationSound(soundFile),
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
