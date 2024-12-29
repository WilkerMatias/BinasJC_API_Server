import '../models/station.dart';
import 'appDatabase.dart';

class StationDatabase {
  final AppDatabase _appDatabase;

  StationDatabase(this._appDatabase);

  Future<int> insert(Station station) async {
    final db = await _appDatabase.database;
    return await db.insert('stations', station.toMap());
  }

  Future<Station?> get(int id) async {
    final db = await _appDatabase.database;
    final maps = await db.query(
      'stations',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Station.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Station>> getAll() async {
    final db = await _appDatabase.database;
    final maps = await db.query('stations');

    return maps.map((map) => Station.fromMap(map)).toList();
  }

  Future<int> update(Station station) async {
    final db = await _appDatabase.database;
    return await db.update(
      'stations',
      station.toMap(),
      where: 'id = ?',
      whereArgs: [station.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _appDatabase.database;
    return await db.delete(
      'stations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
