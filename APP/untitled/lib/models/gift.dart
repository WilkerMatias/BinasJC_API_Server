class Gift {
  final int id;
  String name;
  String description;
  int price;

  Gift({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  // Converte um Gift para JSON (para uso com APIs)
  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
      };

  // Cria uma instância de Gift a partir de JSON (de uma API)
  factory Gift.fromJson(Map<String, dynamic> json) =>
      Gift(
        id: json['id'] as int,
        name: json['name'] as String,
        description: json['description'] as String,
        price: json['price'] as int,
      );
}