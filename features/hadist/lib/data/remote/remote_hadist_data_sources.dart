import 'package:hadist/data/models/hadist_models.dart';
import 'package:dio/dio.dart';

abstract class RemoteHadistDataSources {
  Future<HadistModels> getAllHadist();
}

class RemoteHadistDataSourcesImpl implements RemoteHadistDataSources {
  final Dio dio = Dio();
  @override
  Future<HadistModels> getAllHadist() async {
    await Future.delayed(Duration(seconds: 2));
    final response = await dio.get(
      'https://api.myquran.com/v2/hadits/arbain/semua',
    );
    return HadistModels.fromJson(response.data);
  }
}
