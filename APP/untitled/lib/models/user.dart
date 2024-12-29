import 'dart:convert';

class User {
  final int id;
  String username;
  String email;
  String bi;
  int points;
  int? currentBikeId;
  List<int>? trajectories;
  List<int>? giftEarnedIds; // Novo campo

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.bi,
    this.points = 0,
    this.currentBikeId,
    this.trajectories = const [],
    this.giftEarnedIds = const [], // Inicialização padrão
  });

  // Converte a instância para Map<String, dynamic> (compatível com SQLite)
  Map<String, dynamic> toMap() => {
    'id': id,
    'username': username,
    'email': email,
    'bi': bi,
    'points': points,
    'currentBikeId': currentBikeId,
    'trajectories': jsonEncode(trajectories), // Codifica a lista como JSON
    'giftEarnedIds': jsonEncode(giftEarnedIds), // Codifica a nova lista como JSON
  };

  // Cria uma instância a partir de um Map<String, dynamic> (do SQLite)
  factory User.fromMap(Map<String, dynamic> map) => User(
    id: map['id'] as int,
    username: map['username'] as String,
    email: map['email'] as String,
    bi: map['bi'] as String,
    points: map['points'] as int,
    currentBikeId: map['currentBikeId'] as int?,
    trajectories: List<int>.from(jsonDecode(map['trajectories'] ?? '[]')), // Decodifica JSON para lista
    giftEarnedIds: List<int>.from(jsonDecode(map['giftEarnedIds'] ?? '[]')), // Decodifica JSON para lista
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'bi': bi,
    'points': points,
    'currentBikeId': currentBikeId,
    'trajectories': trajectories,
    'giftEarnedIds': giftEarnedIds, // Inclui no JSON
  };

  // Cria uma instância de User a partir de JSON (de uma API)
  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as int,
    username: json['username'] as String,
    email: json['email'] as String,
    bi: json['bi'] as String,
    points: json['points'] as int,
    currentBikeId: json['currentBikeId'] as int?,
    trajectories: List<int>.from(json['trajectories'] ?? []),
    giftEarnedIds: List<int>.from(json['giftEarnedIds'] ?? []), // Decodifica a nova lista
  );
}
