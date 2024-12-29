import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/models/pointsChat.dart';

import '../datalocal/appDatabase.dart';
import '../datalocal/pointsChat.dart';

class PointsChatService {
  final String baseUrl =
      'http://localhost:8080/api/points-chat'; // Substitua pela URL da API

  // Enviar pontos entre usuários
  Future<PointsChat> sendPoints({
    required int fromUser,
    required int toUser,
    required int points,
  }) async {
    try {
      final appDatabase = AppDatabase.instance;
      final pointsChatDatabase = PointsChatDatabase(appDatabase);
      await pointsChatDatabase.insert(
          PointsChat(fromUser: fromUser, toUser: toUser, points: points));

      final response = await http.post(
        Uri.parse('$baseUrl/send'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fromUserId': fromUser,
          'toUserId': toUser,
          'points': points,
        }),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao enviar pontos: $e');
    }
  }

  // Recuperar um registro específico de PointsChat
  Future<PointsChat> getPointsChat(int chatId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$chatId'));
      if (response.statusCode == 200) {
        return PointsChat.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Erro ao buscar o chat de pontos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar o chat de pontos: $e');
    }
  }

  // Listar todos os registros enviados por um usuário
  Future<List<PointsChat>> getPointsChatsBySender(int fromUserId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/sender/$fromUserId'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => PointsChat.fromJson(json)).toList();
      } else {
        throw Exception(
            'Erro ao buscar registros enviados: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar registros enviados: $e');
    }
  }

  // Listar todos os registros recebidos por um usuário
  Future<List<PointsChat>> getPointsChatsByReceiver(int toUserId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/receiver/$toUserId'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => PointsChat.fromJson(json)).toList();
      } else {
        throw Exception(
            'Erro ao buscar registros recebidos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar registros recebidos: $e');
    }
  }

  // Deletar um registro de PointsChat
  Future<void> deletePointsChat(int chatId) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$chatId'));
      if (response.statusCode != 204) {
        throw Exception(
            'Erro ao deletar o chat de pontos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao deletar o chat de pontos: $e');
    }
  }

  // Método auxiliar para lidar com a resposta
  PointsChat _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        throw Exception('Resposta vazia do servidor');
      }
      try {
        final Map<String, dynamic> decodedJson = jsonDecode(response.body);
        return PointsChat.fromJson(decodedJson);
      } on FormatException catch (e) {
        throw Exception('Erro ao decodificar JSON: $e');
      }
    } else {
      throw Exception(
          'Erro na requisição: ${response.statusCode} - ${response.body}');
    }
  }
}
