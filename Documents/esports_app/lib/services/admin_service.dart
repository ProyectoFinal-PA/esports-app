
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'auth_service.dart';

class AdminService {
  final AuthService _authService = AuthService();

  Future<List<dynamic>> getUsers() async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('No autenticado como Admin');

    final response = await http.get(
      Uri.parse('$apiUrl/api/Admin/users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Falló al cargar usuarios');
    }
  }

  
  Future<bool> promoteUser(int userId) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('No autenticado como Admin');

    final response = await http.post(
      Uri.parse('$apiUrl/api/Admin/promote/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return response.statusCode == 200;
  }

  Future<bool> demoteUser(int userId) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('No autenticado como Admin');

    final response = await http.post(
      Uri.parse('$apiUrl/api/Admin/demote/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return response.statusCode == 200;
  }
}