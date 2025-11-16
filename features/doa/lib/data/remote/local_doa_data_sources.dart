import 'package:core/database_helper.dart';
import 'package:doa/domain/entity/doa_entity.dart';
import 'package:sqflite/sqflite.dart';

abstract class LocalDoaDataSources {
  Future<void> initTables();
  Future<void> insertAllDoa(List<DoaEntity> data);
  Future<List<DoaEntity>> getAllDoa();
}

class LocalDoaDataSourceImpl extends LocalDoaDataSources {
  final DatabaseHelper databaseHelper;

  LocalDoaDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<DoaEntity>> getAllDoa() async {
    await initTables();
    final result = await databaseHelper.query('doa');
    return result.map(DoaEntity.fromMap).toList();
  }

  @override
  Future<void> initTables() async {
    if (!await databaseHelper.tableExists('doa')) {
      await databaseHelper.createTable('doa', {
        'arab': 'TEXT',
        'indo': 'TEXT',
        'judul': 'TEXT',
      });
      print('✅ Table "Doa" created');
    }
  }

  @override
  Future<void> insertAllDoa(List<DoaEntity> data) async {
    await initTables();
    final db = await databaseHelper.database;
    final batch = db.batch();

    for (var doa in data) {
      batch.insert(
        'doa',
        doa.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
    print('📦 Cached ${data.length} Doa');
  }
}
