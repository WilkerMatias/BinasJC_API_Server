import '../models/pointsChat.dart';
import 'appDatabase.dart';

class PointsChatDatabase {
  final AppDatabase _appDatabase;

  PointsChatDatabase(this._appDatabase);

  Future<int> insert(PointsChat chat) async {
    final db = await _appDatabase.database;
    return await db.insert('points_chat', chat.toMap());
  }

  Future<PointsChat?> get(int id) async {
    final db = await _appDatabase.database;
    final maps = await db.query(
      'points_chat',
      where: 'id = ?',
      whereArgs: [id],
    );

    Future<List<PointsChat>> getAll() async {
      final db = await _appDatabase.database;
      final maps = await db.query('points_chat');

      return maps.map((map) => PointsChat.fromMap(map)).toList();
    }

    if (maps.isNotEmpty) {
      return PointsChat.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> update(PointsChat chat) async {
    final db = await _appDatabase.database;
    return await db.update(
      'points_chat',
      chat.toMap(),
      where: 'id = ?',
      whereArgs: [chat.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _appDatabase.database;
    return await db.delete(
      'points_chat',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}