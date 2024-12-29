class PointsChat {
  final int? id; // Adicionado para ser a chave primária no SQLite
  final int fromUser;
  final int toUser;
  final int points;

  PointsChat({
    this.id,
    required this.fromUser,
    required this.toUser,
    required this.points,
  });

  // Converte um PointsChat para Map<String, dynamic> para uso no SQLite
  Map<String, dynamic> toMap() => {
    'id': id,
    'fromUser': fromUser,
    'toUser': toUser,
    'points': points,
  };

  // Cria uma instância de PointsChat a partir de um Map<String, dynamic>
  factory PointsChat.fromMap(Map<String, dynamic> map) => PointsChat(
    id: map['id'] as int,
    fromUser: map['fromUser'] as int,
    toUser: map['toUser'] as int,
    points: map['points'] as int,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'fromUser': fromUser,
    'toUser': toUser,
    'points': points,
  };

  // Cria uma instância de PointsChat a partir de JSON (de uma API)
  factory PointsChat.fromJson(Map<String, dynamic> json) => PointsChat(
    id: json['id'] as int?,
    fromUser: json['fromUser'] as int,
    toUser: json['toUser'] as int,
    points: json['points'] as int,
  );
}