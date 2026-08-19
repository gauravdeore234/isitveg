import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HistoryService {
  static Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'isit_veg.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE scan_history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            raw_text TEXT NOT NULL,
            verdict INTEGER NOT NULL,
            categories TEXT NOT NULL,
            scanned_at TEXT NOT NULL,
            image_path TEXT,
            flagged_json TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> saveScan(Map<String, dynamic> scan) async {
    final db = await database;
    return db.insert('scan_history', scan);
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final db = await database;
    return db.query(
      'scan_history',
      orderBy: 'scanned_at DESC',
    );
  }

  Future<void> deleteScan(int id) async {
    final db = await database;
    await db.delete('scan_history', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearHistory() async {
    final db = await database;
    await db.delete('scan_history');
  }
}
