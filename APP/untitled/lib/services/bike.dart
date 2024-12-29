import 'dart:convert';
import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/datalocal/bike.dart';
import 'package:untitled/models/bike.dart';
import '../datalocal/appDatabase.dart';
import '../models/trajectory.dart';

class BikeService {
  final String baseUrl = 'http://localhost:8080/api/bikes'; // Substitua pela URL base da sua API

  // Listar todas as bikes
  Future<List<Bike>> getAllBikes() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Bike.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao listar bikes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao listar bikes: $e');
    }
  }

  // Buscar bike por ID
  Future<Bike> getBikeById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));
      Bike bike= _handleResponse(response);

      final appDatabase = AppDatabase.instance;
      final bikeDatabase = BikeDatabase(appDatabase);
      await bikeDatabase.insert(bike);

      return bike;

    } catch (e) {
      throw Exception('Erro ao buscar bike por ID: $e');
    }
  }

  // Atualizar localização da bike
  Future<Bike> updateBikeCoords(int id, Coords newLocation) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/$id/location'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newLocation),
      );

      final appDatabase = AppDatabase.instance;
      final bikeDatabase = BikeDatabase(appDatabase);
      Bike? bike = await bikeDatabase.get(id);
      if (bike != null) {
        bike.actualLocation = newLocation;
        await bikeDatabase.update(bike);
        printToConsole('bike coords updated');
      }

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao atualizar localização da bike: $e');
    }
  }

  // Atualizar status da bike
  Future<Bike> updateBikeStatus(int id, String newStatus) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/$id/status?newStatus=$newStatus'),
        headers: {'Content-Type': 'application/json'},
      );

      final appDatabase = AppDatabase.instance;
      final bikeDatabase = BikeDatabase(appDatabase);
      Bike? bike = await bikeDatabase.get(id);
      if (bike != null) {
        bike.status = newStatus;
        await bikeDatabase.update(bike);
        printToConsole('bike status updated');
      }

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao atualizar status da bike: $e');
    }
  }

  // Deletar bike
  Future<void> deleteBike(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 204) {
        return;
      } else {
        throw Exception('Erro ao deletar bike: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao deletar bike: $e');
    }
  }

  // Método auxiliar para lidar com a resposta
  Bike _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        throw Exception('Resposta vazia do servidor');
      }
      try {
        final Map<String, dynamic> decodedJson = jsonDecode(response.body);
        return Bike.fromJson(decodedJson);
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
