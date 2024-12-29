import 'dart:convert';
import 'package:untitled/models/trajectory.dart';

class Station {
  final int id;
  String name;
  Coords location;
  int bikes;

  Station({
    required this.id,
    required this.name,
    required this.location,
    this.bikes = 0,
  });

  // Converte a instância para Map<String, dynamic> (compatível com SQLite)
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'location': jsonEncode({'lat': location.lat, 'lon': location.lon}),
        'bikes': bikes,
      };

  // Cria uma instância a partir de um Map<String, dynamic> (do SQLite)
  factory Station.fromMap (Map<String, dynamic> map) {
    final String locationString = map['location'] as String;
    final Map<String, dynamic> locationMap =
        jsonDecode(locationString) as Map<String, dynamic>;
    return Station(
      id: map['id'] as int,
      name: map['name'] as String,
      location: Coords(
          lat: locationMap['lat'] as double, lon: locationMap['lon'] as double),
      bikes: map['bikes'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'location': {'lat': location.lat, 'lon': location.lon},
    'bikes': bikes,
  };

  // Cria uma instância de Station a partir de JSON (de uma API)
  factory Station.fromJson(Map<String, dynamic> json) => Station(
    id: json['id'] as int,
    name: json['name'] as String,
    location: Coords(
      lat: json['location']['lat'] as double,
      lon: json['location']['lon'] as double,
    ),
    bikes: json['bikes'] as int,
  );

}
