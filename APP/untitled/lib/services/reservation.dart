import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/models/reservation.dart';

import '../datalocal/appDatabase.dart';
import '../datalocal/reservation.dart';

class ReservationService {
  final String baseUrl =
      'http://localhost:8080/api/reservations'; // Substitua pela URL da API

  // Criar nova reserva
  Future<Reservation> createReservation({
    required int userId,
    required int stationId,
    required int bikeId,
  }) async {
    try {
      final appDatabase = AppDatabase.instance;
      final reservationDatabase = ReservationDatabase(appDatabase);

      final response = await http.post(
        Uri.parse('$baseUrl/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'stationId': stationId,
          'bikeId': bikeId,
        }),
      );

      Reservation reservation = _handleResponse(response);
      await reservationDatabase.insert(reservation);
      return reservation;
    } catch (e) {
      throw Exception('Erro ao criar reserva: $e');
    }
  }

  // Cancelar reserva
  Future<void> cancelReservation(int reservationId) async {
    try {
      final appDatabase = AppDatabase.instance;
      final reservationDatabase = ReservationDatabase(appDatabase);
      final response =
      await http.put(Uri.parse('$baseUrl/$reservationId/cancel'));
      _handleResponse(response);
      await reservationDatabase.delete(reservationId);
    } catch (e) {
      throw Exception('Erro ao cancelar reserva: $e');
    }
  }

  // Obter todas as reservas de um usuário
  Future<List<Reservation>> getReservationsByUser(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/user/$userId'));
      return _handleResponseList(response);
    } catch (e) {
      throw Exception('Erro ao buscar reservas do usuário: $e');
    }
  }

  // Obter todas as reservas ativas
  Future<List<Reservation>> getActiveReservations() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/active'));
      return _handleResponseList(response);
    } catch (e) {
      throw Exception('Erro ao buscar reservas ativas: $e');
    }
  }

  // Método auxiliar para lidar com a resposta de um único objeto Reservation
  Reservation _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        throw Exception('Resposta vazia do servidor');
      }
      try {
        final Map<String, dynamic> decodedJson = jsonDecode(response.body);
        return Reservation.fromJson(decodedJson);
      } on FormatException catch (e) {
        throw Exception('Erro ao decodificar JSON: $e');
      }
    }  else if (response.statusCode == 404) {
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

  // Método auxiliar para lidar com a resposta de uma lista de objetos Reservation
  List<Reservation> _handleResponseList(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        throw Exception('Resposta vazia do servidor');
      }
      try {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Reservation.fromJson(json)).toList();
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