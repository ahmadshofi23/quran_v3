import 'package:asmaulhusna/data/repositories/asmaulhusna_repository.dart';
import 'package:asmaulhusna/domain/entity/asmaulhusna_entity.dart';

abstract class AsmaulHusnaUsecase {
  Future<List<AsmaulhusnaEntity>> getAsmaulHusna();
}

class AsmaulHusnaUsecaseImpl extends AsmaulHusnaUsecase {
  final AsmaulhusnaRepository asmaulhusnaRepository;

  AsmaulHusnaUsecaseImpl({required this.asmaulhusnaRepository});

  @override
  Future<List<AsmaulhusnaEntity>> getAsmaulHusna() async {
    return await asmaulhusnaRepository.getAsmaulHusna();
  }
}
