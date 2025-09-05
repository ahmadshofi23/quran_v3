import 'package:doa/data/models/doa_models.dart';
// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart';

abstract class RemoteDoaDataSources {
  Future<DoaModels> getAllDoa();
}

class RemoteDoaDataSourcesImpl implements RemoteDoaDataSources {
  RemoteDoaDataSourcesImpl();
  final Dio dio = Dio();
  @override
  Future<DoaModels> getAllDoa() async {
    await Future.delayed(Duration(seconds: 2));
    final response = await dio.get('https://api.myquran.com/v2/doa/all');
    print('ini response get all doa ${response.data}');
    return DoaModels.fromJson(response.data);
  }
}
