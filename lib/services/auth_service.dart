import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/api_response.dart';

class AuthService {
  final String baseUrl = 'http://localhost:3333';
  final storage = const FlutterSecureStorage();

  Future<ApiResponse> register(String email, String username, String password) async {
    try {
      final response = await http.post(
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

      if (response.statusCode == 201) {
        return ApiResponse(success: true, data: jsonDecode(response.body));
      } else {
        return ApiResponse(success: false, errorMessage: "Erreur d'inscription");
      }
    } catch (e) {
      print('register error');
      print(e);
      return ApiResponse(success: false, errorMessage: "Erreur de réseau ou serveur");
    }
  }

  Future<ApiResponse> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sessions'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token']['token'];
        await saveToken(token);

        return ApiResponse(success: true, data: data);
      } else {
        return ApiResponse(success: false, errorMessage: "Identifiants incorrects");
      }
    } catch (e) {
      print('login error');
      print(e);
      return ApiResponse(success: false, errorMessage: "Erreur de réseau ou serveur");
    }
  }


  Future<ApiResponse> updateUser(Map<String, dynamic> userData) async {
    try {
      String? token = await getToken();
      if (token == null) {
        return ApiResponse(success: false, errorMessage: "Vous n'êtes pas authentifié");
      }

      final response = await http.put(
        Uri.parse('$baseUrl/users'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        return ApiResponse(success: true, data: jsonDecode(response.body));
      } else {
        return ApiResponse(success: false, errorMessage: "Erreur de mise à jour");
      }
    } catch (e) {
      print('updateUser error');
      print(e);
      return ApiResponse(success: false, errorMessage: "Erreur de réseau ou serveur");
    }
  }

  Future<ApiResponse> getUserDetails() async {
    try {
      String? token = await getToken();
      print(token);
      if (token == null) {
        return ApiResponse(success: false, errorMessage: "Vous n'êtes pas authentifié");
      }

      final response = await http.get(
        Uri.parse('$baseUrl/me'),
        headers: <String, String>{'Authorization': 'Bearer $token'},
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        return ApiResponse(success: true, data: jsonDecode(response.body));
      } else {
        return ApiResponse(success: false, errorMessage: "Erreur de récupération des données");
      }
    } catch (e) {
      print('getUserDetails error');
      print(e);
      return ApiResponse(success: false, errorMessage: "Erreur de réseau ou serveur");
    }
  }

  Future<ApiResponse> logout() async {
    try {
      String? token = await getToken();
      if (token == null) {
        return ApiResponse(success: false, errorMessage: "Vous n'êtes pas authentifié");
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/sessions'),
        headers: <String, String>{'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 204) {
        await storage.delete(key: 'authToken');
        return ApiResponse(success: true);
      } else {
        return ApiResponse(success: false, errorMessage: "Déconnexion échouée");
      }
    } catch (e) {
      print('logout error');
      print(e);
      return ApiResponse(success: false, errorMessage: "Erreur de réseau ou serveur");
    }
  }

  Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }
}