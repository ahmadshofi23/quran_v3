import 'package:equatable/equatable.dart';
import 'package:home/domain/entity/jadwal_harian_entity.dart';

class HomeState extends Equatable {
  final String? city;
  final bool loading;
  final String? error;
  final JadwalHarianEntity? jadwalHarian;
  final DateTime? currentTime;
  final String? waktuAktif;
  final String? waktuSalatBerikutnya;
  final String? countdown;

  const HomeState({
    this.city,
    this.loading = false,
    this.error,
    this.jadwalHarian,
    this.currentTime,
    this.waktuAktif,
    this.waktuSalatBerikutnya,
    this.countdown,
  });

  HomeState copyWith({
    String? city,
    bool? loading,
    String? error,
    JadwalHarianEntity? jadwalHarian,
    DateTime? currentTime,
    String? waktuAktif,
    String? waktuSalatBerikutnya,
    String? countdown,
  }) {
    return HomeState(
      city: city ?? this.city,
      loading: loading ?? this.loading,
      error: error,
      jadwalHarian: jadwalHarian ?? this.jadwalHarian,
      currentTime: currentTime ?? this.currentTime,
      waktuAktif: waktuAktif ?? this.waktuAktif,
      waktuSalatBerikutnya: waktuSalatBerikutnya ?? this.waktuSalatBerikutnya,
      countdown: countdown ?? this.countdown,
    );
  }

  @override
  List<Object?> get props => [
    city,
    loading,
    error,
    jadwalHarian,
    currentTime,
    waktuAktif,
    waktuSalatBerikutnya,
    countdown,
  ];
}
