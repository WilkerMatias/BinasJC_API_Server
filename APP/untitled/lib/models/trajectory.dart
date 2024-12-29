
class Coords {
  final double lat;
  final double lon;

  Coords({required this.lat, required this.lon});

  Map<String, dynamic> toJson() => {'lat': lat, 'lon': lon};

  factory Coords.fromJson(Map<String, dynamic> json) {
    return Coords(lat: json['lat'], lon: json['lon']);
  }
}

class Trajectory {
  final int id;
  int user;
  int fromStation;
  int? toStation;
  double distance;
  int pointsEarned;
  DateTime start;
  DateTime? end;
  List<Coords> route;

  Trajectory({
    required this.id,
    required this.user,
    required this.fromStation,
    this.toStation,
    required this.distance,
    required this.pointsEarned,
    required this.start,
    this.end,
    required this.route,
  });

  void addCoord(Coords coords) {
    route.add(coords);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user': user,
    'fromStation': fromStation,
    'toStation': toStation,
    'distance': distance,
    'pointsEarned': pointsEarned,
    'start': start.toIso8601String(),
    'end': end?.toIso8601String(),
    'route': route.map((coord) => coord.toJson()).toList(),
  };

  factory Trajectory.fromJson(Map<String, dynamic> json) {
    return Trajectory(
      id: json['id'],
      user: json['user'],
      fromStation: json['fromStation'],
      toStation: json['toStation'],
      distance: json['distance'].toDouble(),
      pointsEarned: json['pointsEarned'],
      start: DateTime.parse(json['start']),
      end: json['end'] != null ? DateTime.parse(json['end']) : null,
      route: (json['route'] as List)
          .map((item) => Coords.fromJson(item))
          .toList(),
    );
  }
}
