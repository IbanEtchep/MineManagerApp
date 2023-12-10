import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../constants.dart';
import '../models/api_response.dart';

class AuthService {
  final String apiUrl = Constants.apiUrl;

  Future<ApiResponse> register(String email, String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/users'),
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
      return ApiResponse(success: false, errorMessage: "Erreur de réseau ou serveur");
    }
  }

  Future<ApiResponse> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/sessions'),
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
        Uri.parse('$apiUrl/users'),
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
      return ApiResponse(success: false, errorMessage: "Erreur de réseau ou serveur");
    }
  }

  Future<ApiResponse> getUserDetails() async {
    try {
      String? token = await getToken();
      if (token == null) {
        return ApiResponse(success: false, errorMessage: "Vous n'êtes pas authentifié");
      }

      final response = await http.get(
        Uri.parse('$apiUrl/me'),
        headers: <String, String>{'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return ApiResponse(success: true, data: jsonDecode(response.body));
      } else {
        return ApiResponse(success: false, errorMessage: "Erreur de récupération des données");
      }
    } catch (e) {
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
        Uri.parse('$apiUrl/sessions'),
        headers: <String, String>{'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 204) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('authToken');
        return ApiResponse(success: true);
      } else {
        return ApiResponse(success: false, errorMessage: "Déconnexion échouée");
      }
    } catch (e) {
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