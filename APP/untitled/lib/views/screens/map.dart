import 'package:flutter/material.dart';

class Station {
  final String name;
  bool isSelected;
  Station({required this.name, this.isSelected = false});
}

class MapsWidget extends StatefulWidget {
  const MapsWidget({super.key});

  @override
  _MapsWidgetState createState() => _MapsWidgetState();
}

class _MapsWidgetState extends State<MapsWidget> {
  final TextEditingController _searchController = TextEditingController();
  final List<Station> _stations = [
    Station(name: 'Estação 1'),
    Station(name: 'Estação 2'),
    Station(name: 'Estação 3'),
    Station(name: 'Estação 4'),
  ];

  void _toggleStationSelection(int index) {
    setState(() {
      _stations[index].isSelected = !_stations[index].isSelected;
    });
  }

  void _listBikeStations() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Estações'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _stations.map((station) {
              final index = _stations.indexOf(station);
              return ListTile(
                title: Text(station.name),
                trailing: Checkbox(
                  value: station.isSelected,
                  onChanged: (value) {
                    _toggleStationSelection(index);
                  },
                ),
                onTap: () => _toggleStationSelection(index),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Pesquisar...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Lógica de pesquisa (opcional)
              },
            ),
            IconButton(
              icon: const Icon(Icons.directions_bike),
              onPressed: _listBikeStations,
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Tela de Mapa (substituída por lista)'),
      ),
    );
  }
}
