import 'package:hadist/data/repositories/hadist_repository.dart';
import 'package:hadist/domain/entity/hadist_entity.dart';

abstract class HadistUsecase {
  Future<List<HadistEntity>> getAllHadist();
}

class HadistUsecaseImpl implements HadistUsecase {
  final HadistRepository hadistRepository;
  HadistUsecaseImpl({required this.hadistRepository});

  @override
  Future<List<HadistEntity>> getAllHadist() async {
    return await hadistRepository.getAllHadist();
  }
}
