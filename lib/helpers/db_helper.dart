import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task.dart';

class DBHelper {
  static const String _dbName = 'tasks.db';
  static const String _tableName = 'tasks';

  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, _dbName),
      version: 2, // 🔥 Incrementou a versão do banco
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            firebaseId TEXT,
            title TEXT,
            description TEXT,
            isDone INTEGER,
            isSynced INTEGER
          )
          ''',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db
              .execute('ALTER TABLE $_tableName ADD COLUMN firebaseId TEXT;');
          await db.execute(
              'ALTER TABLE $_tableName ADD COLUMN isSynced INTEGER DEFAULT 0;');
        }
      },
    );
  }

  static Future<void> insert(Task task) async {
    final db = await DBHelper.database();
    await db.insert(
      _tableName,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Task>> getTasks() async {
    final db = await DBHelper.database();
    final data = await db.query(_tableName);
    return data.map((item) => Task.fromMap(item)).toList();
  }

  static Future<List<Task>> getUnsyncedTasks() async {
    final db = await DBHelper.database();
    final data = await db.query(
      _tableName,
      where: 'isSynced = ?',
      whereArgs: [0],
    );
    return data.map((item) => Task.fromMap(item)).toList();
  }

  static Future<void> update(Task task) async {
    final db = await DBHelper.database();
    await db.update(
      _tableName,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  static Future<void> delete(int id) async {
    final db = await DBHelper.database();
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
