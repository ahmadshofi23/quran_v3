import 'package:equatable/equatable.dart';
import 'package:home/domain/entity/jadwal_harian_entity.dart';

class HomeState extends Equatable {
  final String? city;
  final bool loading;
  final String? error;
  final JadwalHarianEntity? jadwalHarian;
  final String? waktuAktif;

  const HomeState({
    this.city,
    this.loading = false,
    this.error,
    this.jadwalHarian,
    this.waktuAktif,
  });

  HomeState copyWith({
    String? city,
    bool? loading,
    String? error,
    JadwalHarianEntity? jadwalHarian,
    String? waktuAktif,
  }) {
    return HomeState(
      city: city ?? this.city,
      loading: loading ?? this.loading,
      error: error,
      jadwalHarian: jadwalHarian ?? this.jadwalHarian,
      waktuAktif: waktuAktif ?? this.waktuAktif,
    );
  }

  @override
  List<Object?> get props => [city, loading, error, jadwalHarian, waktuAktif];
}
