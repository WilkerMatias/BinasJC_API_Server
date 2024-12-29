import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/giftEarned.dart';

class GiftEarnedService {
  final String baseUrl = 'http://localhost:8080/api/gift-earned'; // Substitua pela URL base da API

  // Registrar um Gift Earned
  Future<GiftEarned> createGiftEarned(int userId, int giftId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl?userId=$userId&giftId=$giftId'),
        headers: {'Content-Type': 'application/json'},
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao criar Gift Earned: $e');
    }
  }

  // Buscar GiftEarned por ID
  Future<GiftEarned> getGiftEarnedById(int giftEarnedId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$giftEarnedId'));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao buscar Gift Earned por ID: $e');
    }
  }

  // Atualizar o status de uso de um GiftEarned
  Future<GiftEarned> updateGiftUsedStatus(int giftEarnedId, bool newStatus) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/$giftEarnedId/used?newStatus=$newStatus'),
        headers: {'Content-Type': 'application/json'},
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao atualizar status de uso: $e');
    }
  }

  // Listar todos os GiftsEarned de um usuário
  Future<List<GiftEarned>> getGiftsEarnedByUser(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/user/$userId'));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => GiftEarned.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao listar Gifts Earned: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao listar Gifts Earned: $e');
    }
  }

  // Deletar um GiftEarned por ID
  Future<void> deleteGiftEarned(int giftEarnedId) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$giftEarnedId'));
      if (response.statusCode == 204) {
        return;
      } else {
        throw Exception('Erro ao deletar Gift Earned: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao deletar Gift Earned: $e');
    }
  }

  // Método auxiliar para lidar com a resposta
  GiftEarned _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        throw Exception('Resposta vazia do servidor');
      }
      try {
        final Map<String, dynamic> decodedJson = jsonDecode(response.body);
        return GiftEarned.fromJson(decodedJson);
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
