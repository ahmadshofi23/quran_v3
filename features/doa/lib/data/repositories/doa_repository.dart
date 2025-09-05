import 'package:doa/domain/entity/doa_entity.dart';

abstract class DoaRepository {
  Future<List<DoaEntity>> getAllDoa();
}
