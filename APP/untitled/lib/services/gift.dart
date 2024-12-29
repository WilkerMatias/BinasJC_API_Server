import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/models/gift.dart';

class GiftService {
  final String baseUrl = 'http://localhost:8080/api/gifts'; // Substitua pela URL base da sua API

  // Criar um novo Gift
  Future<Gift> createGift(String name, String description, int price) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'description': description,
          'price': price,
        }),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao criar Gift: $e');
    }
  }

  // Buscar Gift por ID
  Future<Gift> getGiftById(int giftId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$giftId'));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao buscar Gift por ID: $e');
    }
  }

  // Atualizar o nome de um Gift
  Future<Gift> updateGiftName(int giftId, String newName) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/$giftId/name?newName=$newName'),
        headers: {'Content-Type': 'application/json'},
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao atualizar nome do Gift: $e');
    }
  }

  // Atualizar a descrição de um Gift
  Future<Gift> updateGiftDescription(int giftId, String newDescription) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/$giftId/description?newDescription=$newDescription'),
        headers: {'Content-Type': 'application/json'},
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao atualizar descrição do Gift: $e');
    }
  }

  // Atualizar o preço de um Gift
  Future<Gift> updateGiftPrice(int giftId, int newPrice) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/$giftId/price?newPrice=$newPrice'),
        headers: {'Content-Type': 'application/json'},
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao atualizar preço do Gift: $e');
    }
  }

  // Listar todos os Gifts
  Future<List<Gift>> getAllGifts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Gift.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao listar Gifts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao listar Gifts: $e');
    }
  }

  // Deletar um Gift por ID
  Future<void> deleteGift(int giftId) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$giftId'));
      if (response.statusCode == 204) {
        return;
      } else {
        throw Exception('Erro ao deletar Gift: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao deletar Gift: $e');
    }
  }

  // Método auxiliar para lidar com a resposta
  Gift _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        throw Exception('Resposta vazia do servidor');
      }
      try {
        final Map<String, dynamic> decodedJson = jsonDecode(response.body);
        return Gift.fromJson(decodedJson);
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
