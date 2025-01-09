import 'package:flutter/material.dart';
import 'package:untitled/datalocal/station.dart';
import 'package:untitled/services/reservation.dart';
import 'package:untitled/services/station.dart';
import '../../datalocal/appDatabase.dart';
import '../../datalocal/reservation.dart';
import '../../datalocal/user.dart';
import '../../models/bike.dart';
import '../../models/reservation.dart';
import '../../models/station.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  List<Station> _stations = [];
  bool _isBikeConnected = false;
  Station? _selectedStation;
  Reservation? _activeReservation; // Para armazenar a reserva ativa
  Bike? _selectedBike;

  @override
  void initState() {
    super.initState();
    _fetchStations();
    _checkActiveReservation(); // Verifica se já existe uma reserva ativa ao iniciar
  }

  Future<void> _fetchStations() async {
    try {
      final stations = await StationService().getAllStations();
      setState(() {
        _stations = stations;
      });
    } catch (e) {
      try {
        final appDatabase = AppDatabase.instance;
        final stationDatabase = StationDatabase(appDatabase);
        final stations = await stationDatabase.getAll();
        setState(() {
          _stations = stations;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar estações: $e')),
        );
      }
    }
  }

  // Verifica se já existe uma reserva ativa
  Future<void> _checkActiveReservation() async {
    try {
      final appDatabase = AppDatabase.instance;
      final reservationDatabase = ReservationDatabase(appDatabase);
      final activeReservations = await reservationDatabase.getAll();
      setState(() {
        _activeReservation = activeReservations.isNotEmpty
            ? activeReservations
                .firstWhere((reservation) => reservation.status == true)
            : null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao verificar reservas ativas: $e')),
      );
    }
  }

  // Função para realizar a reserva
  Future<void> _doReservation() async {
    if (_selectedStation != null &&
        _selectedStation!.bikes > 0 &&
        _activeReservation == null) {
      final appDatabase = AppDatabase.instance;
      try {
        final userDatabase = UserDatabase(appDatabase);
        final user = await userDatabase.getAll();
        final userId = user.first.id;

        // Cria a reserva sem a escolha de uma bicicleta
        final reservation = await ReservationService().createReservation(
          userId: userId,
          stationId: _selectedStation!.id,
          bikeId: 0, // 0 ou valor nulo, pois a bicicleta não é escolhida
        );

        setState(() {
          _activeReservation =
              reservation; // Atualiza o estado com a nova reserva ativa
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao realizar reserva: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Já existe uma reserva ativa ou sem bicicletas disponíveis.')),
      );
    }
  }

  // Função para alternar entre conectar e desconectar a bicicleta
  void _toggleConnection() {
    setState(() {
      if (_isBikeConnected) {
        _isBikeConnected = false;
        _selectedBike = null;
      } else {
        _isBikeConnected = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            _isBikeConnected ? 'Bicicleta Conectada' : 'Reservar Bicicleta'),
      ),
      body: Center(
        child: _stations.isEmpty
            ? const CircularProgressIndicator() // Exibe carregamento enquanto busca as estações
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: !_isBikeConnected && _activeReservation == null,
                    // Mostra o formulário de reserva se não houver uma reserva ativa
                    child: Column(
                      children: [
                        DropdownButton<Station>(
                          value: _selectedStation,
                          hint: const Text('Selecione uma Estação'),
                          items: _stations.map((station) {
                            return DropdownMenuItem(
                              value: station,
                              child: Text(
                                '${station.name} - Localização: (${station.location.lat}, ${station.location.lon}) '
                                '${station.bikes > 0 ? "(Disponível)" : "(Sem Bikes)"}',
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedStation = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _selectedStation != null &&
                                  _selectedStation!.bikes > 0
                              ? _doReservation
                              : null,
                          child: const Text('Reservar'),
                        ),
                      ],
                    ),
                  ),
                  if (_activeReservation !=
                      null) // Exibe a informação da reserva ativa
                    Column(
                      children: [
                        Text(
                          'Reserva Ativa:\n'
                          'Estação: ${_selectedStation?.name}\n'
                          'Status: ${_activeReservation!.status ? "Ativa" : "Cancelada"}',
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  Visibility(
                    visible: _isBikeConnected && _activeReservation == null,
                    // Não permite conectar se houver uma reserva ativa
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: _toggleConnection,
                          child: const Text('Conectar'),
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
