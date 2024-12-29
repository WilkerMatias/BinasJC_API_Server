class Reservation {
  final int id;
  int user;
  int bike;
  int station;
  bool status;
  DateTime date;

  Reservation({
    required this.id,
    required this.user,
    required this.bike,
    required this.station,
    required this.status,
    required this.date,
  });

  // Converte a instância para Map<String, dynamic> (compatível com SQLite)
  Map<String, dynamic> toMap() => {
    'id': id,
    'user': user,
    'bike': bike,
    'station': station,
    'status': status ? 1 : 0, // SQLite não tem tipo booleano, usamos 1 e 0
    'date': date.toIso8601String(),
  };

  // Cria uma instância a partir de um Map<String, dynamic> (do SQLite)
  factory Reservation.fromMap(Map<String, dynamic> map) => Reservation(
    id: map['id'] as int,
    user: map['user'] as int,
    bike: map['bike'] as int,
    station: map['station'] as int,
    status: map['status'] == 1,
    date: DateTime.parse(map['date']),
  );
  Map<String, dynamic> toJson() => {
    'id': id,
    'user': user,
    'bike': bike,
    'station': station,
    'status': status,
    'date': date.toIso8601String(),
  };

  // Cria uma instância de Reservation a partir de JSON (de uma API)
  factory Reservation.fromJson(Map<String, dynamic> json) => Reservation(
    id: json['id'] as int,
    user: json['user'] as int,
    bike: json['bike'] as int,
    station: json['station'] as int,
    status: json['status'] as bool,
    date: DateTime.parse(json['date'] as String),
  );
}
