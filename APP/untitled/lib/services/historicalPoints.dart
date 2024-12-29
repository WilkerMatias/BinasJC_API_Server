import 'dart:convert';
import 'package:http/http.dart' as http;
import '../datalocal/appDatabase.dart';
import '../datalocal/historicalPoints.dart';
import '../models/historicalPoints.dart';

class HistoricalPointsService {
  final String baseUrl = 'http://localhost:8080/api/historical-points';
  final AppDatabase appDatabase = AppDatabase.instance;

  // Listar todos os registros
  Future<List<HistoricalPoints>> getAllHistoricalPoints() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => HistoricalPoints.fromJson(json)).toList();
      } else {
        throw Exception(
            'Erro ao buscar todos os registros: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar todos os registros: $e');
    }
  }

  // Buscar registros por usuário
  Future<List<HistoricalPoints>> getHistoricalPointsByUser(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/user/$userId'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => HistoricalPoints.fromJson(json)).toList();
      } else {
        throw Exception(
            'Erro ao buscar registros por usuário: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar registros por usuário: $e');
    }
  }

  // Criar um novo registro
  Future<HistoricalPoints> createHistoricalPoint({
    required int userId,
    required int processId,
    required Type type,
    required int points,
  }) async {
    try {
      final HistoricalPointsDatabase database =
          HistoricalPointsDatabase(appDatabase);

      // Inserir na base de dados local
      await database.insert(HistoricalPoints(
        user: userId,
        process: processId,
        type: type,
        points: points,
        used: false,
      ));

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'processId': processId,
          'type': type,
          'points': points,
        }),
      );

      if (response.statusCode == 200) {
        return HistoricalPoints.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Erro ao criar registro: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao criar registro: $e');
    }
  }

  // Atualizar o status de uso de um registro
  Future<HistoricalPoints> updateUsedStatus({
    required int id,
    required bool used,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'used': used}),
      );

      if (response.statusCode == 200) {
        final HistoricalPointsDatabase database =
            HistoricalPointsDatabase(appDatabase);

        HistoricalPoints? hPoints = await database.get(id);
        if (hPoints != null) {
          hPoints.used = used;
          await database.update(hPoints);
        }

        return HistoricalPoints.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Erro ao atualizar status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao atualizar status: $e');
    }
  }

  // Deletar um registro
  Future<void> deleteHistoricalPoint(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 204) {
        final HistoricalPointsDatabase database =
            HistoricalPointsDatabase(appDatabase);
        // Remover da base de dados local
        await database.delete(id);
      } else {
        throw Exception('Erro ao deletar registro: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao deletar registro: $e');
    }
  }
}
