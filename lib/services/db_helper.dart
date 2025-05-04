import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'denomination.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE denominations(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        remark TEXT,
        total INTEGER NOT NULL,
        amount_text TEXT NOT NULL,
        d2000 INTEGER NOT NULL,
        d500 INTEGER NOT NULL,
        d200 INTEGER NOT NULL,
        d100 INTEGER NOT NULL,
        d50 INTEGER NOT NULL,
        d20 INTEGER NOT NULL,
        d10 INTEGER NOT NULL,
        d5 INTEGER NOT NULL,
        d2 INTEGER NOT NULL,
        d1 INTEGER NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertDenomination(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('denominations', row);
  }

  Future<List<Map<String, dynamic>>> getDenominations() async {
    Database db = await database;
    return await db.query('denominations', orderBy: 'created_at DESC');
  }

  Future<Map<String, dynamic>> getDenomination(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'denominations',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.first;
  }

  Future<int> updateDenomination(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.update(
      'denominations',
      row,
      where: 'id = ?',
      whereArgs: [row['id']],
    );
  }

  Future<int> deleteDenomination(int id) async {
    Database db = await database;
    return await db.delete(
      'denominations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}