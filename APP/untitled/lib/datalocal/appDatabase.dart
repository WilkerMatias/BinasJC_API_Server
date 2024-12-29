import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE historical_points (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user INTEGER NOT NULL,
      process INTEGER NOT NULL,
      type TEXT NOT NULL,
      points INTEGER NOT NULL,
      used INTEGER NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE points_chat (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      fromUser INTEGER NOT NULL,
      toUser INTEGER NOT NULL,
      points INTEGER NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE bikes (
      id INTEGER PRIMARY KEY,
      actualLocation TEXT,
      status TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE reservations (
      id INTEGER PRIMARY KEY,
      user INTEGER NOT NULL,
      bike INTEGER NOT NULL,
      station INTEGER NOT NULL,
      status INTEGER NOT NULL,
      date TEXT NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE stations (
      id TEXT PRIMARY KEY,
      location TEXT NOT NULL,
      bikes INTEGER
    )
    ''');

    await db.execute('''
    CREATE TABLE trajectories (
      id INTEGER PRIMARY KEY,
      user INTEGER NOT NULL,
      fromStation INTEGER NOT NULL,
      toStation INTEGER NOT NULL,
      distance REAL NOT NULL,
      pointsEarned INTEGER NOT NULL,
      start TEXT NOT NULL,
      end TEXT NOT NULL,
      route TEXT NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY,
      username TEXT NOT NULL,
      email TEXT NOT NULL,
      points INTEGER NOT NULL,
      currentBikeId INTEGER,
      trajectories TEXT,
      giftEarnedIds TEXT -- Novo campo adicionado
    )
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}


// void main() async {
//   // Inicializa o banco de dados
//   final appDatabase = AppDatabase.instance;
//
//   // Cria as instâncias das classes de banco de dados
//   final historicalPointsDatabase = HistoricalPointsDatabase(appDatabase);
//   final pointsChatDatabase = PointsChatDatabase(appDatabase);
//
//   // Exemplo de uso:
//   // Inserir um HistoricalPoint
//   final newHistoricalPoint = HistoricalPoints(
//     user: 1,
//     process: 1,
//     type: 'gift',
//     points: 10,
//     used: false,
//   );
//   await historicalPointsDatabase.insertHistoricalPoint(newHistoricalPoint);
//
//   // Inserir um PointsChat
//   final newPointsChat = PointsChat(
//     fromUser: 1,
//     toUser: 2,
//     points: 5,
//   );
//   await pointsChatDatabase.insertPointsChat(newPointsChat);
//
//   // ... outras operações ...
//
//   // Fechar o banco de dados quando não for mais necessário
//   await appDatabase.close();
// }