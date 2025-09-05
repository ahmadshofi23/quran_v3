import 'package:doa/data/repositories/doa_repository.dart';
import 'package:doa/domain/entity/doa_entity.dart';

abstract class DoaUsecase {
  Future<List<DoaEntity>> getAllDoa();
}

class DoaUsecaseImpl extends DoaUsecase {
  final DoaRepository doaRepository;
  DoaUsecaseImpl({required this.doaRepository});

  @override
  Future<List<DoaEntity>> getAllDoa() async {
    return await doaRepository.getAllDoa();
  }
}
