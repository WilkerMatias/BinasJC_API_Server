import '../models/trajectory.dart';
import 'appDatabase.dart';

class TrajectoryDatabase {
  final AppDatabase _appDatabase;

  TrajectoryDatabase(this._appDatabase);

  Future<int> insert(Trajectory trajectory) async {
    final db = await _appDatabase.database;
    return await db.insert('trajectories', trajectory.toJson());
  }

  Future<Trajectory?> get(int id) async {
    final db = await _appDatabase.database;
    final maps = await db.query(
      'trajectories',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Trajectory.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Trajectory>> getAll() async {
    final db = await _appDatabase.database;
    final maps = await db.query('trajectories');

    return maps.map((map) => Trajectory.fromJson(map)).toList();
  }

  Future<int> update(Trajectory trajectory) async {
    final db = await _appDatabase.database;
    return await db.update(
      'trajectories',
      trajectory.toJson(),
      where: 'id = ?',
      whereArgs: [trajectory.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _appDatabase.database;
    return await db.delete(
      'trajectories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}
