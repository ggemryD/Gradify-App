import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/history_model.dart';

class DatabaseHelper {
  static Database? _database;

  // Initialize the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'gradify.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE history(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            gwa REAL NOT NULL,
            semester TEXT NOT NULL,
            isDeanLister INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  // Insert a new history record
  Future<int> insertHistory(HistoryModel history) async {
    final db = await database;
    return await db.insert('history', history.toMap());
  }

  // Fetch all history records
  Future<List<HistoryModel>> getHistory() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query('history', orderBy: "id DESC");
    return results.map((map) => HistoryModel.fromMap(map)).toList();
  }

  // Delete a history record
  Future<int> deleteHistory(int id) async {
    final db = await database;
    return await db.delete('history', where: 'id = ?', whereArgs: [id]);
  }

  // Clear all history
  Future<void> clearHistory() async {
    final db = await database;
    await db.delete('history');
  }
}
