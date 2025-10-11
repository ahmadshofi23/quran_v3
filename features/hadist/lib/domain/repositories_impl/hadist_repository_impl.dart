import 'package:hadist/data/remote/remote_hadist_data_sources.dart';
import 'package:hadist/data/repositories/hadist_repository.dart';
import 'package:hadist/domain/entity/hadist_entity.dart';

class HadistRepositoryImpl implements HadistRepository {
  final RemoteHadistDataSources remoteHadistDataSources;
  HadistRepositoryImpl({required this.remoteHadistDataSources});

  @override
  Future<List<HadistEntity>> getAllHadist() async {
    List<HadistEntity> dataHadist = [];
    final response = await remoteHadistDataSources.getAllHadist();
    if (response.data != null && response.data!.isNotEmpty) {
      dataHadist =
          response.data!
              .map(
                (e) => HadistEntity(
                  arab: e.arab,
                  indo: e.indo,
                  judul: e.judul,
                  no: e.no,
                ),
              )
              .toList();
    }
    return dataHadist;
  }
}
