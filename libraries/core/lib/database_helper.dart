import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:developer';

class DatabaseHelper {
  // Singleton pattern agar hanya satu instance database aktif
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  // Getter untuk database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inisialisasi database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'quran_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        log('🧱 Creating default table...');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS default_table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT
          )
        ''');
      },
      onOpen: (db) {
        log('✅ Database opened: $path');
      },
    );
  }

  // ===============================
  // 🔹 Utility Functions
  // ===============================

  /// Membuat tabel baru jika belum ada
  Future<void> createTable(
    String tableName,
    Map<String, String> columns,
  ) async {
    final db = await database;
    final columnDefs = columns.entries
        .map((e) => '${e.key} ${e.value}')
        .join(', ');
    final sql = 'CREATE TABLE IF NOT EXISTS $tableName ($columnDefs)';
    await db.execute(sql);
    log('📦 Table created or exists: $tableName');
  }

  /// Mengecek apakah tabel sudah ada
  Future<bool> tableExists(String tableName) async {
    final db = await database;
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      [tableName],
    );
    final exists = result.isNotEmpty;
    log('🔍 Table "$tableName" exists: $exists');
    return exists;
  }

  /// Insert data ke tabel (return rowId)
  Future<int> insert(String tableName, Map<String, dynamic> data) async {
    final db = await database;
    try {
      final id = await db.insert(
        tableName,
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      log('✅ Inserted into $tableName → id: $id');
      return id;
    } catch (e) {
      log('❌ Error inserting into $tableName: $e');
      rethrow;
    }
  }

  /// Batch insert untuk performa tinggi
  Future<void> batchInsert(
    String tableName,
    List<Map<String, dynamic>> dataList,
  ) async {
    if (dataList.isEmpty) return;
    final db = await database;
    final batch = db.batch();
    for (var data in dataList) {
      batch.insert(
        tableName,
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
    log('📤 Batch inserted ${dataList.length} items into $tableName');
  }

  /// Query semua data atau dengan kondisi tertentu
  Future<List<Map<String, dynamic>>> query(
    String tableName, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
  }) async {
    final db = await database;
    return await db.query(
      tableName,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
    );
  }

  /// Update data berdasarkan kondisi
  Future<int> update(
    String tableName,
    Map<String, dynamic> data,
    String where,
    List<dynamic> args,
  ) async {
    final db = await database;
    return await db.update(tableName, data, where: where, whereArgs: args);
  }

  /// Delete data berdasarkan kondisi
  Future<int> delete(String tableName, String where, List<dynamic> args) async {
    final db = await database;
    return await db.delete(tableName, where: where, whereArgs: args);
  }

  /// Drop (hapus) tabel
  Future<void> dropTable(String tableName) async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS $tableName');
    log('🗑️ Dropped table: $tableName');
  }

  /// Clear (hapus semua data dalam tabel)
  Future<void> clearTable(String tableName) async {
    final db = await database;
    await db.delete(tableName);
    log('🧹 Cleared table: $tableName');
  }

  /// Tutup koneksi database
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
      log('🔒 Database closed.');
    }
  }
}
