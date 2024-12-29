import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/models/station.dart';

import '../datalocal/appDatabase.dart';
import '../datalocal/station.dart';
import '../models/trajectory.dart';

class StationService {
  final String baseUrl =
      'http://localhost:8080/api/stations'; // Substitua pela sua URL base

  // Listar todas as estações
  Future<List<Station>> getAllStations() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        List<Station> stations =
            jsonList.map((json) => Station.fromJson(json)).toList();
        final appDatabase = AppDatabase.instance;
        final stationDatabase = StationDatabase(appDatabase);
        for (Station stationFromJson in stations) {
          Station? stationFromDatabase =
              await stationDatabase.get(stationFromJson.id);
          // Se a estação não existir, inseri-la
          if (stationFromDatabase == null) {
            await stationDatabase.insert(stationFromJson);
          }
        }
        return stations;
      } else {
        throw Exception('Erro ao listar estações: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao listar estações: $e');
    }
  }

  // Buscar estação por ID
  Future<Station> getStationById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao buscar estação por ID: $e');
    }
  }

  // Criar nova estação
  Future<Station> createStation(String name, Coords location) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create?name=$name'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(location),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao criar estação: $e');
    }
  }

  // Atualizar nome da estação
  Future<Station> updateStationName(int id, String newName) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id/update-name?newName=$newName'),
        headers: {'Content-Type': 'application/json'},
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao atualizar nome da estação: $e');
    }
  }

  // Atualizar localização da estação
  Future<Station> updateStationLocation(int id, Coords newLocation) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id/update-location'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newLocation),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao atualizar localização da estação: $e');
    }
  }

  // Adicionar bike à estação
  Future<Station> addBikeToStation(int stationId, int bikeId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$stationId/add-bike/$bikeId'),
        headers: {'Content-Type': 'application/json'},
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao adicionar bike à estação: $e');
    }
  }

  // Remover bike da estação
  Future<Station> removeBikeFromStation(int stationId, int bikeId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$stationId/remove-bike/$bikeId'),
        headers: {'Content-Type': 'application/json'},
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao remover bike da estação: $e');
    }
  }

  // Deletar estação
  Future<void> deleteStation(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 204) {
        return;
      } else {
        throw Exception('Erro ao deletar estação: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao deletar estação: $e');
    }
  }

  // Método auxiliar para lidar com a resposta
  Station _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        throw Exception('Resposta vazia do servidor');
      }
      try {
        final Map<String, dynamic> decodedJson = jsonDecode(response.body);
        return Station.fromJson(decodedJson);
      } on FormatException catch (e) {
        throw Exception('Erro ao decodificar JSON: $e');
      }
    } else if (response.statusCode == 404) {
      throw Exception('Recurso não encontrado (404)');
    } else if (response.statusCode == 401) {
      throw Exception('Não autorizado (401)');
    } else if (response.statusCode == 403) {
      throw Exception('Acesso proibido (403)');
    } else if (response.statusCode == 500) {
      throw Exception('Erro interno do servidor (500)');
    } else {
      throw Exception(
          'Erro na requisição: ${response.statusCode} - ${response.body}');
    }
  }
}
