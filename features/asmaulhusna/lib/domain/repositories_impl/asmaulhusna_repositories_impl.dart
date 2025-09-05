import 'package:asmaulhusna/data/remote/remote_asmaulhusna_data_sources.dart';

import '../../data/repositories/asmaulhusna_repository.dart';
import '../entity/asmaulhusna_entity.dart';

class AsmaulhusnaRepositoriesImpl extends AsmaulhusnaRepository {
  final RemoteAsmaulHusnaDataSources remoteAsmaulHusnaDataSources;

  AsmaulhusnaRepositoriesImpl({required this.remoteAsmaulHusnaDataSources});

  @override
  Future<List<AsmaulhusnaEntity>> getAsmaulHusna() async {
    List<AsmaulhusnaEntity> dataAsmaulHusna = [];

    final response = await remoteAsmaulHusnaDataSources.getAsmaulHusna();
    if (response.data != null && response.data!.isNotEmpty) {
      dataAsmaulHusna =
          response.data!
              .map(
                (e) => AsmaulhusnaEntity(
                  arab: e.arab,
                  id: e.id,
                  indo: e.indo,
                  latin: e.latin,
                ),
              )
              .toList();
    }
    return dataAsmaulHusna;
  }
}
