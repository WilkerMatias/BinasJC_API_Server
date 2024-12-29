import '../models/bike.dart';
import 'appDatabase.dart';

class BikeDatabase {
  final AppDatabase _appDatabase;

  BikeDatabase(this._appDatabase);

  Future<int> insert(Bike bike) async {
    final db = await _appDatabase.database;
    return await db.insert('bikes', bike.toMap());
  }

  Future<Bike?> get(int id) async {
    final db = await _appDatabase.database;
    final maps = await db.query(
      'bikes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Bike.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Bike>> getAll() async {
    final db = await _appDatabase.database;
    final maps = await db.query('bikes');

    return maps.map((map) => Bike.fromMap(map)).toList();
  }

  Future<int> update(Bike bike) async {
    final db = await _appDatabase.database;
    return await db.update(
      'bikes',
      bike.toMap(),
      where: 'id = ?',
      whereArgs: [bike.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _appDatabase.database;
    return await db.delete(
      'bikes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}
