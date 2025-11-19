// lib/services/partida_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http; 
import 'api_config.dart';
import 'auth_service.dart'; 

class PartidaService {
  final AuthService _authService = AuthService();

  Future<List<dynamic>> getPartidas(int tournamentId) async {
    final response = await http.get(
      Uri.parse('$apiUrl/api/Partidas/torneo/$tournamentId'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Falló al cargar las partidas');
    }
  }

  Future<bool> createPartida(int tournamentId, int teamAId, int teamBId, DateTime scheduledTime, String? twitchChannel) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('No autenticado');
    
    final response = await http.post(
      Uri.parse('$apiUrl/api/Partidas'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'tournamentId': tournamentId,
        'teamA_Id': teamAId,
        'teamB_Id': teamBId,
        'scheduledTime': scheduledTime.toIso8601String(), 
        'twitchChannelName': twitchChannel,
      }),
    );
    return response.statusCode == 200; 
  }

  Future<bool> registerResultado(int partidaId, int scoreA, int scoreB, int winnerId) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('No autenticado');

    final response = await http.post(
      Uri.parse('$apiUrl/api/Partidas/$partidaId/resultado'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'scoreTeamA': scoreA,
        'scoreTeamB': scoreB,
        'winnerTeamId': winnerId,
      }),
    );
    return response.statusCode == 200;
  }
}