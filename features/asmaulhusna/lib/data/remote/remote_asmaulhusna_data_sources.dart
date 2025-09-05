import 'package:asmaulhusna/data/models/asmaulhusna_model.dart';
// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart';

abstract class RemoteAsmaulHusnaDataSources {
  Future<AsmaulHusnaModels> getAsmaulHusna();
}

class RemoteAsmaulHusnaDataSourcesImpl extends RemoteAsmaulHusnaDataSources {
  final dio = Dio();
  @override
  Future<AsmaulHusnaModels> getAsmaulHusna() async {
    try {
      final response = await dio.get('https://api.myquran.com/v2/husna/semua');
      print('object $response');
      if (response.statusCode == 200) {
        return AsmaulHusnaModels.fromJson(response.data);
      } else {
        throw Exception('Failed to load Asmaul Husna');
      }
    } catch (e) {
      throw Exception('Failed to load Asmaul Husna: $e');
    }
  }
}
