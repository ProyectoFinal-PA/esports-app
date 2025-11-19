// lib/services/tournament_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'auth_service.dart';

class TournamentService {
  final AuthService _authService = AuthService();

  Future<List<dynamic>> getTournaments() async {
  
    final response = await http.get(
      Uri.parse('$apiUrl/api/Tournaments'), 
    

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Falló al cargar torneos (Código: ${response.statusCode})');
    }
  }

  Future<bool> createTournament(String name, String game, DateTime startDate) async {
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception('No estás autenticado o no eres Organizador.');
    }

    final response = await http.post(
      Uri.parse('$apiUrl/api/Tournaments'), 
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', 
      },
      body: jsonEncode({
        'name': name,
        'game': game,
        'startDate': startDate.toIso8601String(), 
      }),
    );
  
    
    return response.statusCode == 201; 
  }
}