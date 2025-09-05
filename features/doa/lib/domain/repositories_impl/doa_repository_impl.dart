import 'package:doa/data/remote/remote_doa_data_sources.dart';
import 'package:doa/domain/entity/doa_entity.dart';

import '../../data/repositories/doa_repository.dart';

class DoaRepositoryImpl extends DoaRepository {
  final RemoteDoaDataSources remoteDoaDataSources;
  DoaRepositoryImpl({required this.remoteDoaDataSources});

  @override
  Future<List<DoaEntity>> getAllDoa() async {
    List<DoaEntity> dataDoa = [];

    final response = await remoteDoaDataSources.getAllDoa();
    if (response.data != null && response.data!.isNotEmpty) {
      dataDoa =
          response.data!
              .map((e) => DoaEntity(arab: e.arab, indo: e.indo, judul: e.judul))
              .toList();
    }

    return dataDoa;
  }
}
