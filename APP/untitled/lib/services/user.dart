import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/datalocal/user.dart';
import 'package:untitled/models/user.dart';

import '../datalocal/appDatabase.dart';

class UserService {
  final String baseUrl = 'http://localhost:8080/api/users'; // Substitua pela sua URL base

  Future<User> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );
      User user = _handleResponse(response);

      final appDatabase = AppDatabase.instance;
      final userDatabase = UserDatabase(appDatabase);
      await userDatabase.insert(user);
      return user;

    } catch (e) {
      throw Exception('Erro ao fazer login: $e');
    }
  }

  Future<User> createUser(String username, String email, String bi, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'bi': bi,
          'password': password,
        }),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao criar usuário: $e');
    }
  }

  Future<User> getUserById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$id'),
        headers: {'Accept': 'application/json'},
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao obter usuário por ID: $e');
    }
  }

  Future<User> getUserByEmail(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/email?email=$email'),
        headers: {'Accept': 'application/json'},
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao obter usuário por email: $e');
    }
  }

  Future<User> getUserByUsername(String username) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/username?username=$username'),
        headers: {'Accept': 'application/json'},
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao obter usuário por username: $e');
    }
  }

  Future<User> updateUsername(int id, String newUsername) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id/username'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'newUsername': newUsername}),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao atualizar username: $e');
    }
  }

  Future<User> updatePassword(int id, String newPassword) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id/password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'newPassword': newPassword}),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao atualizar senha: $e');
    }
  }

  Future<bool> updateBike(int userId, int bikeId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$userId/bike'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'bikeId': bikeId}),
      );
      User user = _handleResponse(response);

      final appDatabase = AppDatabase.instance;
      final userDatabase = UserDatabase(appDatabase);
      await userDatabase.update(user);
      return true;

    } catch (e) {
      throw Exception('Erro ao atualizar bicicleta: $e');
    }
  }

  Future<User> updateGifts(int userId, int giftId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$userId/gifts'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'giftId': giftId}),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao atualizar presentes: $e');
    }
  }

  Future<User> deactivateUser(int id) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id/deactivate'),
        headers: {'Content-Type': 'application/json'},
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao desativar usuário: $e');
    }
  }

  Future<User> reactivateUser(int id) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id/reactivate'),
        headers: {'Content-Type': 'application/json'},
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao reativar usuário: $e');
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 204) {
        return;
      } else {
        throw Exception('Erro ao deletar usuário: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao deletar usuário: $e');
    }
  }

  // Método auxiliar para lidar com a resposta
  User _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        throw Exception('Resposta vazia do servidor');
      }
      try {
        final Map<String, dynamic> decodedJson = jsonDecode(response.body);
        return User.fromJson(decodedJson);
      } on FormatException catch (e) {
        throw Exception('Erro ao decodificar JSON: $e');
      }
    } else {
      throw Exception(
          'Erro na requisição: ${response.statusCode} - ${response.body}');
    }
  }
}
