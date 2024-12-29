import '../models/historicalPoints.dart';
import 'appDatabase.dart'; // Importa a classe AppDatabase

class HistoricalPointsDatabase {
  final AppDatabase _appDatabase;

  HistoricalPointsDatabase(this._appDatabase);

  Future<int> insert(HistoricalPoints point) async {
    final db = await _appDatabase.database;
    return await db.insert('historical_points', point.toMap());
  }

  Future<HistoricalPoints?> get(int id) async {
    final db = await _appDatabase.database;
    final maps = await db.query(
      'historical_points',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return HistoricalPoints.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<HistoricalPoints>> getAll() async {
    final db = await _appDatabase.database;
    final maps = await db.query('historical_points');

    return maps.map((map) => HistoricalPoints.fromMap(map)).toList();
  }

  Future<int> update(HistoricalPoints point) async {
    final db = await _appDatabase.database;
    return await db.update(
      'historical_points',
      point.toMap(),
      where: 'id = ?',
      whereArgs: [point.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _appDatabase.database;
    return await db.delete(
      'historical_points',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}