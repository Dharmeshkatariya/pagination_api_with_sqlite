// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import '../models/todo_model.dart';
//
//
// class TodoDatabaseHelper {
//   static final TodoDatabaseHelper instance = TodoDatabaseHelper._init();
//   static Database? _database;
//
//   TodoDatabaseHelper._init();
//
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await initDB('todo_database.db');
//     return _database!;
//   }
//
//   Future<Database> initDB(String filePath) async {
//     final path = join(await getDatabasesPath(), filePath);
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _createDB,
//     );
//   }
//
//   Future<void> _createDB(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE todos (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         userId INTEGER NOT NULL,
//         title TEXT NOT NULL,
//         completed INTEGER NOT NULL
//       )
//     ''');
//   }
//
//   Future<int> insertTodo(TodoModel todo) async {
//     final db = await database;
//     return await db.insert('todos', todo.toJson());
//   }
//
//   Future<List<TodoModel>> getTodos({int limit = 10, int offset = 0}) async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query(
//       'todos',
//       limit: limit,
//       offset: offset,
//     );
//     return List.generate(maps.length, (i) {
//       return TodoModel.fromJson(maps[i]);
//     });
//   }
// }
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/todo_model.dart';

class TodoDatabaseHelper {
  static final TodoDatabaseHelper instance = TodoDatabaseHelper._privateConstructor();
  static Database? _database;

  TodoDatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }
  Future<List<int>> getAllTodoIds() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('todos', columns: ['id']);

    // Extract the 'id' values from the query result
    final List<int> ids = result.map((map) => map['id'] as int).toList();

    return ids;
  }


  Future<Database> initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'todos.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        title TEXT,
        completed INTEGER
      )
    ''');
  }

  Future<void> insertPaginatedData(List<TodoModel> newData) async {
    final db = await database;
    final batch = db.batch();

    for (final todo in newData) {
      batch.insert('todos', todo.toJson());
    }

    await batch.commit(noResult: true);
  }
}
