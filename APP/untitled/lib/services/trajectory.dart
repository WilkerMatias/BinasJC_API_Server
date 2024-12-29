import 'dart:convert';
import 'package:http/http.dart' as http;
import '../datalocal/appDatabase.dart';
import '../datalocal/trajectory.dart';
import '../models/trajectory.dart';

class TrajectoryService {
  final String baseUrl = 'http://localhost:8080/api/trajectories'; // URL base

  // Criar nova trajetória com coordenada inicial
  Future<Trajectory> createTrajectory(
      int userId, int fromStation, Coords initialCoords) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create?userId=$userId&fromStation=$fromStation'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(initialCoords),
      );

      Trajectory trajectory = _handleResponse(response);

      final appDatabase = AppDatabase.instance;
      final trajectoryDatabase = TrajectoryDatabase(appDatabase);
      await trajectoryDatabase.insert(trajectory);
      return trajectory;
    } catch (e) {
      throw Exception('Erro ao criar trajetória: $e');
    }
  }

  // Adicionar coordenada à trajetória existente
  Future<Trajectory> addCoordsToTrajectory(
      int trajectoryId, Coords newCoords) async {
    try {
      final appDatabase = AppDatabase.instance;
      final trajectoryDatabase = TrajectoryDatabase(appDatabase);
      Trajectory? trajectory = await trajectoryDatabase.get(trajectoryId);

      if (trajectory != null) {
        trajectory.addCoord(newCoords);
        await trajectoryDatabase.update(trajectory);
      } else {
        print('Trajetória não encontrada no banco de dados local.');
      }

      final response = await http.put(
        Uri.parse('$baseUrl/$trajectoryId/add-coords'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newCoords),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao adicionar coordenada: $e');
    }
  }

  // Finalizar trajetória
  Future<Trajectory> endTrajectory(int trajectoryId, int toStation) async {
    try {
      final appDatabase = AppDatabase.instance;
      final trajectoryDatabase = TrajectoryDatabase(appDatabase);
      Trajectory? trajectory = await trajectoryDatabase.get(trajectoryId);

      if (trajectory != null && trajectory.end == null) {
        trajectory.end = DateTime.now();
        await trajectoryDatabase.update(trajectory);
      } else {
        print('Trajetória não encontrada ou já finalizada.');
      }

      final response = await http.put(
        Uri.parse('$baseUrl/$trajectoryId/end?toStation=$toStation'),
        headers: {'Content-Type': 'application/json'},
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao finalizar trajetória: $e');
    }
  }

  // Listar trajetórias por usuário
  Future<List<Trajectory>> getTrajectoriesByUser(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/$userId'),
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Trajectory.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao listar trajetórias: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao listar trajetórias: $e');
    }
  }

  // Método auxiliar para lidar com a resposta
  Trajectory _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        throw Exception('Resposta vazia do servidor');
      }
      try {
        final Map<String, dynamic> decodedJson = jsonDecode(response.body);
        return Trajectory.fromJson(decodedJson);
      } on FormatException catch (e) {
        throw Exception('Erro ao decodificar JSON: $e');
      }
    } else {
      if (response.statusCode == 404) {
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

  void _handleErrorResponse(http.Response response) {
    if (response.statusCode == 404) {
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
