import 'package:core/database_helper.dart';
import 'package:surah/domain/entities/ayat_entities.dart';
import 'package:surah/domain/entities/surah_entities.dart';
import 'package:sqflite/sqflite.dart';

abstract class LocalQuranDataSources {
  Future<void> initTables();
  Future<void> insertAllSurah(List<SurahEntity> data);
  Future<List<SurahEntity>> getAllSurah();
  Future<void> insertAllAyat(List<AyatEntity> data);
  Future<List<AyatEntity>> getAyatBySurah(int surahNumber);
}

class LocalQuranDataSourcesImpl extends LocalQuranDataSources {
  final DatabaseHelper databaseHelper;

  LocalQuranDataSourcesImpl({required this.databaseHelper});

  @override
  Future<void> initTables() async {
    if (!await databaseHelper.tableExists('surah')) {
      await databaseHelper.createTable('surah', {
        'nomor': 'INTEGER PRIMARY KEY',
        'nama': 'TEXT',
        'nama_latin': 'TEXT',
        'jumlah_ayat': 'INTEGER',
        'tempat_turun': 'TEXT',
        'arti': 'TEXT',
        'deskripsi': 'TEXT',
        'audio': 'TEXT',
      });
      print('✅ Table "surah" created');
    }

    if (!await databaseHelper.tableExists('detail_surah')) {
      await databaseHelper.createTable('detail_surah', {
        'id': 'INTEGER PRIMARY KEY AUTOINCREMENT',
        'surah_number': 'INTEGER',
        'nomor': 'INTEGER',
        'ar': 'TEXT',
        'idn': 'TEXT',
        'tr': 'TEXT',
      });
      print('✅ Table "detail_surah" created');
    }
  }

  @override
  Future<void> insertAllSurah(List<SurahEntity> data) async {
    await initTables();
    final db = await databaseHelper.database;
    final batch = db.batch();

    for (var surah in data) {
      batch.insert(
        'surah',
        surah.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
    print('📦 Cached ${data.length} Surah');
  }

  @override
  Future<List<SurahEntity>> getAllSurah() async {
    await initTables();
    final result = await databaseHelper.query('surah');
    return result.map(SurahEntity.fromMap).toList();
  }

  @override
  Future<void> insertAllAyat(List<AyatEntity> data) async {
    await initTables();
    final db = await databaseHelper.database;
    final batch = db.batch();

    for (var ayat in data) {
      batch.insert(
        'detail_surah',
        ayat.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
    print('📦 Cached ${data.length} Ayat');
  }

  @override
  Future<List<AyatEntity>> getAyatBySurah(int surahNumber) async {
    await initTables();
    final result = await databaseHelper.query(
      'detail_surah',
      where: 'surah_number = ?',
      whereArgs: [surahNumber],
    );
    return result.map(AyatEntity.fromMap).toList();
  }
}
