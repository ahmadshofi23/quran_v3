import 'package:asmaulhusna/domain/entity/asmaulhusna_entity.dart';

abstract class AsmaulhusnaRepository {
  Future<List<AsmaulhusnaEntity>> getAsmaulHusna();
}
