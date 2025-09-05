import 'package:surah/domain/entities/ayat_entities.dart';

import '../entities/surah_entities.dart';

abstract class QuranRepository {
  Future<List<SurahEntity>> getAllSurah();

  Future<List<AyatEntity>> getDetailSurah(int numberOfSurah);
}
