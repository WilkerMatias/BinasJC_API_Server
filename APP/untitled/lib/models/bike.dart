import 'dart:convert';

import 'package:untitled/models/trajectory.dart';

class Bike {
  final int id;
  Coords? actualLocation;
  String? status;

  Bike({
    required this.id,
    this.status,
    this.actualLocation,
  });

  // Converte um Bike para Map<String, dynamic> para uso no SQLite
  Map<String, dynamic> toMap() => {
    'id': id,
    'actualLocation': jsonEncode({'lat': actualLocation?.lat, 'lon': actualLocation?.lon}),
    'status': status,
  };

  factory Bike.fromMap (Map<String, dynamic> map) {
    final String locationString = map['actualLocation'] as String;
    final Map<String, dynamic> locationMap = jsonDecode(locationString) as Map<String, dynamic>;
    return Bike(
        id: map['id'] as int,
        actualLocation: Coords(
        lat: locationMap['lat'] as double, lon: locationMap['lon'] as double),
    status: map['status'] as String);
  }

  factory Bike.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? locationMap = json['actualLocation'];
    Coords? location;
    if (locationMap != null) {
      location = Coords(
          lat: locationMap['lat'] as double, lon: locationMap['lon'] as double);
    }
    return Bike(
      id: json['id'] as int,
      actualLocation: location,
      status: json['status'] as String?,
    );
  }
}
