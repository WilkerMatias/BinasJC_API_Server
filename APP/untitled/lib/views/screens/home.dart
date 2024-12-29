import 'package:flutter/material.dart';

// Definição das classes
class Coords {
  final double lat;
  final double lon;
  Coords(this.lat, this.lon);
}

class Bike {
  final String id;
  String status; // 'STATION', 'RESERVED', 'USE'
  Coords location;

  Bike(this.id, this.status, this.location);
}

class Station {
  final String id;
  final Coords location;
  final List<Bike> bikes;

  Station(this.id, this.location, this.bikes);

  // Verifica se há bicicletas disponíveis na estação
  bool hasAvailableBikes() {
    return bikes.any((bike) => bike.status == 'STATION');
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  bool _isBikeConnected = false;
  Station? _selectedStation;
  Bike? _selectedBike;

  // Lista de estações e bicicletas
  final List<Station> _stations = [
    Station(
      'Estação 1',
      Coords(0.0, 0.0),
      [
        Bike('Bike A', 'STATION', Coords(0.0, 0.0)),
        Bike('Bike B', 'STATION', Coords(0.0, 0.0)),
      ],
    ),
    Station(
      'Estação 2',
      Coords(1.0, 1.0),
      [
        Bike('Bike C', 'STATION', Coords(1.0, 1.0)),
      ],
    ),
    Station(
      'Estação 3',
      Coords(2.0, 2.0),
      [
        Bike('Bike D', 'USE', Coords(2.0, 2.0)), // Ocupada
        Bike('Bike E', 'RESERVED', Coords(2.0, 2.0)), // Reservada
      ],
    ),
  ];

  void _toggleConnection() {
    setState(() {
      if (_isBikeConnected) {
        // Desconectar bicicleta
        _selectedBike?.status = 'STATION';
        _isBikeConnected = false;
        _selectedBike = null;
      } else if (_selectedBike != null) {
        // Conectar bicicleta
        _selectedBike?.status = 'USE';
        _isBikeConnected = true;
      }
    });
  }

  void _reserveBike() {
    if (_selectedStation != null && _selectedBike != null) {
      setState(() {
        if (_selectedBike!.status == 'STATION') {
          // Reservar bicicleta
          _selectedBike!.status = 'RESERVED';
          _isBikeConnected = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isBikeConnected ? 'Bicicleta Conectada' : 'Reservar Bicicleta'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: !_isBikeConnected,
              child: Column(
                children: [
                  DropdownButton<Station>(
                    value: _selectedStation,
                    hint: const Text('Selecione uma Estação'),
                    items: _stations.map((station) {
                      return DropdownMenuItem(
                        value: station,
                        child: Text(
                          '${station.id} - Localização: (${station.location.lat}, ${station.location.lon}) '
                              '${station.hasAvailableBikes() ? "(Disponível)" : "(Sem Bikes)"}',
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedStation = value;
                        _selectedBike = null; // Resetar a bike ao trocar de estação
                      });
                    },
                  ),
                  if (_selectedStation != null && _selectedStation!.hasAvailableBikes())
                    DropdownButton<Bike>(
                      value: _selectedBike,
                      hint: const Text('Selecione uma Bike'),
                      items: _selectedStation!.bikes
                          .where((bike) => bike.status == 'STATION')
                          .map((bike) {
                        return DropdownMenuItem(
                          value: bike,
                          child: Text(bike.id),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedBike = value;
                        });
                      },
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: (_selectedStation != null &&
                        _selectedStation!.hasAvailableBikes() &&
                        _selectedBike != null)
                        ? _reserveBike
                        : null,
                    child: const Text('Reservar'),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _isBikeConnected,
              child: Column(
                children: [
                  Text(
                    'Estação: ${_selectedStation?.id}\n'
                        'Bicicleta: ${_selectedBike?.id}\n'
                        'Status: ${_selectedBike?.status}',
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _toggleConnection,
                    child: const Text('Desconectar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
