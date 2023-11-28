import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final String baseUrl = 'http://localhost:3333';

  Future<http.Response> register(String email, String username, String password) async {
    return await http.post(
      Uri.parse('$baseUrl/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'username': username,
        'password': password,
      }),
    );
  }

  Future<http.Response> login(String email, String password) async {
    return await http.post(
      Uri.parse('$baseUrl/sessions'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
  }

  Future<http.Response> getUserDetails(String token) async {
    return await http.get(
      Uri.parse('$baseUrl/me'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> updateUser(String token, Map<String, dynamic> userData) async {
    return await http.put(
      Uri.parse('$baseUrl/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(userData),
    );
  }

  Future<http.Response> logout(String token) async {
    return await http.delete(
      Uri.parse('$baseUrl/sessions'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
  }
}