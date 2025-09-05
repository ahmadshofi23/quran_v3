import 'package:home/data/models/city_models.dart';
import 'package:dio/dio.dart';
import 'package:home/data/models/jadwal_harian_models.dart';

abstract class HomeRemoteDataSources {
  Future<CityModels> getIdCities(String city);
  Future<JadwalHarianModels> getJadwalHarian(String idKota, String date);
}

class HomeRemoteDataSourcesImpl implements HomeRemoteDataSources {
  final Dio dio = Dio();

  @override
  Future<CityModels> getIdCities(String city) async {
    // Simulate a network call
    await Future.delayed(Duration(seconds: 2));
    print('Fetching city ID for: $city');
    final response = await dio.get(
      'https://api.myquran.com/v2/sholat/kota/cari/$city',
    );

    return CityModels.fromJson(response.data);
  }

  @override
  Future<JadwalHarianModels> getJadwalHarian(String idKota, String date) async {
    await Future.delayed(Duration(seconds: 2));
    final response = await dio.get(
      'https://api.myquran.com/v2/sholat/jadwal/$idKota/$date',
    );
    print('response data: ${response.data}');
    return JadwalHarianModels.fromJson(response.data);
  }
}
