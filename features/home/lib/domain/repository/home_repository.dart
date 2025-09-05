import 'package:home/domain/entity/jadwal_harian_entity.dart';

abstract class HomeRepository {
  Future<String> getIdCity(String city);
  Future<JadwalHarianEntity> getJadwalHarian(String city);
}
