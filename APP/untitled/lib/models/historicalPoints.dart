enum Type {
  SEND, GIFT, RECEIVED, TRAJECTORY
}

class HistoricalPoints {
  final int? id; // Adicionado para ser a chave primária no SQLite
  final int user;
  final int process; // gift, trajectory, etc
  final Type type; // Convertido para String para facilitar o uso no SQLite
  final int points;
  late final bool used;

  HistoricalPoints({
    this.id,
    required this.user,
    required this.process,
    required this.type,
    required this.points,
    required this.used,
  });

  // Converte um HistoricalPoints para Map<String, dynamic> para uso no SQLite
  Map<String, dynamic> toMap() => {
    'id': id,
    'user': user,
    'process': process,
    'type': type,
    'points': points,
    'used': used ? 1 : 0, // Converte bool para int (1 ou 0)
  };

  // Cria uma instância de HistoricalPoints a partir de um Map<String, dynamic>
  factory HistoricalPoints.fromMap(Map<String, dynamic> map) => HistoricalPoints(
    id: map['id'] as int,
    user: map['user'] as int,
    process: map['process'] as int,
    type: map['type'] as Type,
    points: map['points'] as int,
    used: map['used'] == 1, // Converte int para bool
  );

  // Converte um HistoricalPoints para JSON (para uso com APIs)
  Map<String, dynamic> toJson() => {
    'id': id,
    'user': user,
    'process': process,
    'type': type,
    'points': points,
    'used': used,
  };

  // Cria uma instância de HistoricalPoints a partir de JSON (de uma API)
  factory HistoricalPoints.fromJson(Map<String, dynamic> json) => HistoricalPoints(
    id: json['id'] as int?,
    user: json['user'] as int,
    process: json['process'] as int,
    type: json['type'] as Type,
    points: json['points'] as int,
    used: json['used'] as bool,
  );
}
