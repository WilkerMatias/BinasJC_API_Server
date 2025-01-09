import '../models/user.dart';
import 'appDatabase.dart';

class UserDatabase {
  final AppDatabase _appDatabase;

  UserDatabase(this._appDatabase);

  Future<int> insert(User user) async {
    final db = await _appDatabase.database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> get(int id) async {
    final db = await _appDatabase.database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<User>> getAll() async {
    final db = await _appDatabase.database;
    final maps = await db.query('users');

    return maps.map((map) => User.fromMap(map)).toList();
  }

  Future<int> update(User user) async {
    final db = await _appDatabase.database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _appDatabase.database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    _appDatabase.close();
  }
}
