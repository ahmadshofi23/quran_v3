import 'package:home/data/remote/home_remote_data_sources.dart';
import 'package:home/domain/entity/jadwal_harian_entity.dart';
import 'package:home/domain/repository/home_repository.dart';
import 'package:intl/intl.dart';

class HomeRepositoriesImpl extends HomeRepository {
  final HomeRemoteDataSources remoteDataSources;

  HomeRepositoriesImpl({required this.remoteDataSources});

  @override
  Future<String> getIdCity(String city) async {
    print('ini di repo $city');
    final response = await remoteDataSources.getIdCities(city);
    if (response.data != null && response.data!.isNotEmpty) {
      return response.data![0].id ?? '';
    } else {
      throw Exception('No data found for the specified city');
    }
  }

  @override
  Future<JadwalHarianEntity> getJadwalHarian(String city) async {
    final date = DateTime.now();
    final formatteDate = DateFormat('yyyy-MM-dd').format(date);
    print('date: $formatteDate');
    final idKota = await getIdCity(city);
    final response = await remoteDataSources.getJadwalHarian(
      idKota,
      formatteDate,
    );
    return JadwalHarianEntity(
      ashar: response.data?.jadwal?.ashar,
      dhuha: response.data?.jadwal?.dhuha,
      dzuhur: response.data?.jadwal?.dzuhur,
      imsak: response.data?.jadwal?.imsak,
      isya: response.data?.jadwal?.isya,
      maghrib: response.data?.jadwal?.maghrib,
      subuh: response.data?.jadwal?.subuh,
      terbit: response.data?.jadwal?.terbit,
    );
  }
}
