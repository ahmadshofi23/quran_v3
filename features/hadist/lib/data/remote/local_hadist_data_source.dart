import 'package:core/database_helper.dart';
import 'package:hadist/domain/entity/hadist_entity.dart';
import 'package:sqflite/sqflite.dart';

abstract class LocalHadistDataSource {
  Future<void> initTables();
  Future<void> insertAllHadist(List<HadistEntity> data);
  Future<List<HadistEntity>> getAllHadist();
}

class LocalHadistDataSourceImpl extends LocalHadistDataSource {
  final DatabaseHelper databaseHelper;
  LocalHadistDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<HadistEntity>> getAllHadist() async {
    await initTables();
    final result = await databaseHelper.query('hadist');
    return result.map(HadistEntity.fromMap).toList();
  }

  @override
  Future<void> initTables() async {
    if (!await databaseHelper.tableExists('hadist')) {
      await databaseHelper.createTable('hadist', {
        'arab': 'TEXT',
        'indo': 'TEXT',
        'judul': 'TEXT',
        'no': 'TEXT',
      });
      print('✅ Table "Hadst" created');
    }
  }

  @override
  Future<void> insertAllHadist(List<HadistEntity> data) async {
    await initTables();
    final db = await databaseHelper.database;
    final batch = db.batch();
    for (var hadist in data) {
      batch.insert(
        'hadist',
        hadist.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
    print('📦 Cached ${data.length} Hadist');
  }
}
