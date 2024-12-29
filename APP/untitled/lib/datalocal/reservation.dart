
import '../models/reservation.dart';
import 'appDatabase.dart';

class ReservationDatabase {
  final AppDatabase _appDatabase;
  ReservationDatabase(this._appDatabase);

  Future<int> insert(Reservation reservation) async {
    final db = await _appDatabase.database;
    return await db.insert('reservations', reservation.toMap());
  }

  Future<Reservation?> get(int id) async {
    final db = await _appDatabase.database;
    final maps = await db.query(
      'reservations',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Reservation.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Reservation>> getAll() async {
    final db = await _appDatabase.database;
    final maps = await db.query('reservations');

    return maps.map((map) => Reservation.fromMap(map)).toList();
  }

  Future<int> update(Reservation reservation) async {
    final db = await _appDatabase.database;
    return await db.update(
      'reservations',
      reservation.toMap(),
      where: 'id = ?',
      whereArgs: [reservation.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _appDatabase.database;
    return await db.delete(
      'reservations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}
