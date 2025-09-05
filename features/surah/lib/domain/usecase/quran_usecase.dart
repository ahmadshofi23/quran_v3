import 'package:surah/domain/entities/ayat_entities.dart';
import 'package:surah/domain/entities/surah_entities.dart';
import 'package:surah/domain/repositories/quran_repository.dart';

abstract class QuranUseCase {
  Future<List<SurahEntity>> getAllSurah();

  Future<List<AyatEntity>> getDetailSurah(int numberOfSurah);
}

class QuranUseCaseImpl extends QuranUseCase {
  final QuranRepository quranRepository;

  QuranUseCaseImpl({required this.quranRepository});

  @override
  Future<List<SurahEntity>> getAllSurah() {
    return quranRepository.getAllSurah();
  }

  @override
  Future<List<AyatEntity>> getDetailSurah(int numberOfSurah) async {
    return quranRepository.getDetailSurah(numberOfSurah);
  }
}
