import 'package:hadist/domain/entity/hadist_entity.dart';

abstract class HadistRepository {
  Future<List<HadistEntity>> getAllHadist();
}
