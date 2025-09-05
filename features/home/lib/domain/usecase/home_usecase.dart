import 'package:home/domain/entity/jadwal_harian_entity.dart';
import 'package:home/domain/repository/home_repository.dart';

abstract class HomeUsecase {
  Future<String> getIdCity(String city);
  Future<JadwalHarianEntity> getJadwalHarian(String idKota);
}

class HomeUsecaseImpl implements HomeUsecase {
  final HomeRepository repository;

  HomeUsecaseImpl({required this.repository});

  @override
  Future<String> getIdCity(String city) async {
    return await repository.getIdCity(city);
  }

  @override
  Future<JadwalHarianEntity> getJadwalHarian(String city) async {
    return await repository.getJadwalHarian(city);
  }
}
