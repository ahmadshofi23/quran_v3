import '../models/surah_model.dart';
import '../models/detail_surah_model.dart';
import 'package:dio/dio.dart';

abstract class RemoteQuranDataSource {
  Future<List<DaftarSurah>> getAllSurah();
  Future<DetailSurahModel> getDetailSurah(int nomorSurah);
}

class RemoteQuranDataSourceImpl extends RemoteQuranDataSource {
  // final Dio dio;
  final Dio dio = Dio();

  RemoteQuranDataSourceImpl();

  @override
  Future<List<DaftarSurah>> getAllSurah() async {
    List<DaftarSurah> daftarSurah = [];
    dio.options.headers['Content-Type'] = 'application/json';
    final response = await dio.get('https://equran.id/api/surat');
    if (response.statusCode != 200) {
      throw Exception('Failed to load surah');
    }

    for (var item in response.data) {
      daftarSurah.add(DaftarSurah.fromJson(item));
    }

    return daftarSurah;
  }

  @override
  Future<DetailSurahModel> getDetailSurah(int nomorSurah) async {
    final response = await dio.get('https://equran.id/api/surat/$nomorSurah');
    print(response.data);
    if (response.statusCode != 200) {
      throw Exception('Failed to load detail surah');
    }
    return DetailSurahModel.fromJson(response.data);
  }
}
