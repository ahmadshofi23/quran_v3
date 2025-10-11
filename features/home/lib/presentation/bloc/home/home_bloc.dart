import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/domain/entity/jadwal_harian_entity.dart';
import 'package:home/domain/usecase/home_usecase.dart';
import 'package:home/presentation/bloc/home/home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeUsecase homeUsecase;
  Timer? _timer;

  HomeBloc({required this.homeUsecase})
    : super(const HomeState(loading: true)) {
    on<GetIdCity>(_getIdCity);
    on<UpdateCurrentTime>(_onUpdateCurrentTime);

    // Jalankan timer setiap detik
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(UpdateCurrentTime());
    });
  }

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
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }

  void _onUpdateCurrentTime(UpdateCurrentTime event, Emitter<HomeState> emit) {
    final now = DateTime.now();

    final waktuAktif = _tentukanWaktuSalatAktif(now, state.jadwalHarian);
    final nextPrayerInfo = _tentukanWaktuSalatBerikutnya(
      now,
      state.jadwalHarian,
    );

    emit(
      state.copyWith(
        currentTime: now,
        waktuAktif: waktuAktif,
        waktuSalatBerikutnya: nextPrayerInfo['nama'],
        countdown: nextPrayerInfo['countdown'],
      ),
    );
  }

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
    return aktif ?? 'Belum masuk waktu salat';
  }

  /// Tentukan waktu salat berikutnya dan countdown-nya
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
        final formatted = _formatDuration(diff);
        return {'nama': item['nama'], 'countdown': formatted};
      }
    }

    // Kalau semua sudah lewat, waktu berikutnya adalah imsak hari besok
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

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
