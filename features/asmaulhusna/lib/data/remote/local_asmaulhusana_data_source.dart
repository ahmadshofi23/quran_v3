import 'package:asmaulhusna/domain/entity/asmaulhusna_entity.dart';
import 'package:core/database_helper.dart';
import 'package:sqflite/sqflite.dart';

abstract class LocalAsmaulHusnaDataSource {
  Future<void> initTable();
  Future<void> insertAsmaulHusna(List<AsmaulhusnaEntity> data);
  Future<List<AsmaulhusnaEntity>> getAllAsmaulHusna();
}

class LocalAsmaulhusanaDataSourceImpl extends LocalAsmaulHusnaDataSource {
  final DatabaseHelper databaseHelper;

  LocalAsmaulhusanaDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<AsmaulhusnaEntity>> getAllAsmaulHusna() async {
    await initTable();
    final result = await databaseHelper.query('asmaul_husna');
    return result.map(AsmaulhusnaEntity.fromMap).toList();
  }

  @override
  Future<void> initTable() async {
    if (!await databaseHelper.tableExists('asmaul_husna')) {
      await databaseHelper.createTable('asmaul_husna', {
        'id': 'INTEGER',
        'arab': 'TEXT',
        'indo': 'TEXT',
        'latin': 'TEXT',
      });
    }

    print('✅ Table "asmaul husna" created');
  }

  @override
  Future<void> insertAsmaulHusna(List<AsmaulhusnaEntity> data) async {
    await initTable();
    final db = await databaseHelper.database;
    final batch = db.batch();
    for (var asmaulHusna in data) {
      batch.insert(
        'asmaul_husna',
        asmaulHusna.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
    print('📦 Cached ${data.length} Asmaul Husna');
  }
}
