
class GiftEarned {
  final int gift; // Adicionado para ser a chave primária no SQLite
  String name;
  DateTime date;
  bool used;

  GiftEarned(this.gift, this.name, this.date, this.used);

  // Converte um GiftEarned para JSON (para uso com APIs)
  Map<String, dynamic> toJson() =>
      {
        'gift': gift,
        'name': name,
        'date': date.toIso8601String(),
        'used': used,
      };

  // Cria uma instância de GiftEarned a partir de JSON (de uma API)
  factory GiftEarned.fromJson(Map<String, dynamic> json) =>
      GiftEarned(
        json['gift'] as int,
        json['name'] as String,
        DateTime.parse(json['date'] as String),
        json['used'] as bool,
      );
}