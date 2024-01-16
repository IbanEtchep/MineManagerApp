import 'package:http/http.dart' as http;
import 'package:mine_manager/services/auth_service.dart';
import 'dart:convert';

import '../constants.dart';
import '../models/api_response.dart';

class DockerService {
  final AuthService authService;
  final String apiUrl = Constants.apiUrl;

  DockerService(this.authService);

  Future<ApiResponse> getContainersList() async {
    try {
      String? token = await authService.getToken();
      if (token == null) {
        return ApiResponse(
            success: false, errorMessage: "Vous n'êtes pas authentifié");
      }

      final response = await http.get(
        Uri.parse('$apiUrl/docker/containers'),
        headers: <String, String>{'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return ApiResponse(success: true, data: jsonDecode(response.body));
      } else {
        return ApiResponse(
            success: false,
            errorMessage:
                "Erreur de récupération des données. Code erreur ${response.statusCode}");
      }
    } catch (e) {
      return ApiResponse(
          success: false, errorMessage: "Erreur de réseau ou serveur");
    }
  }

  Future<ApiResponse> getContainer(String id) async {
    try {
      String? token = await authService.getToken();
      if (token == null) {
        return ApiResponse(
            success: false, errorMessage: "Vous n'êtes pas authentifié");
      }

      final response = await http.get(
        Uri.parse('$apiUrl/docker/containers/$id'),
        headers: <String, String>{'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return ApiResponse(success: true, data: jsonDecode(response.body));
      } else {
        return ApiResponse(success: false,
            errorMessage: "Erreur de récupération des données. Code erreur ${response
                .statusCode}");
      }
    } catch (e) {
      return ApiResponse(
          success: false, errorMessage: "Erreur de réseau ou serveur");
    }
  }

  Future<ApiResponse> startContainer(String id) async {
    try {
      String? token = await authService.getToken();
      if (token == null) {
        return ApiResponse(
            success: false, errorMessage: "Vous n'êtes pas authentifié");
      }

      final response = await http.post(
        Uri.parse('$apiUrl/docker/containers/$id/start'),
        headers: <String, String>{'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return ApiResponse(success: true);
      } else {
        return ApiResponse(success: false,
            errorMessage: "Erreur de récupération des données. Code erreur ${response
                .statusCode}");
      }
    } catch (e) {
      return ApiResponse(
          success: false, errorMessage: "Erreur de réseau ou serveur");
    }
  }

  Future<ApiResponse> stopContainer(String id) async {
    try {
      String? token = await authService.getToken();
      if (token == null) {
        return ApiResponse(
            success: false, errorMessage: "Vous n'êtes pas authentifié");
      }

      final response = await http.post(
        Uri.parse('$apiUrl/docker/containers/$id/stop'),
        headers: <String, String>{'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return ApiResponse(success: true, data: jsonDecode(response.body));
      } else {
        return ApiResponse(success: false,
            errorMessage: "Erreur de récupération des données. Code erreur ${response
                .statusCode}");
      }
    } catch (e) {
      return ApiResponse(
          success: false, errorMessage: "Erreur de réseau ou serveur");
    }
  }

  Future<ApiResponse> restartContainer(String id) async {
    try {
      String? token = await authService.getToken();
      if (token == null) {
        return ApiResponse(
            success: false, errorMessage: "Vous n'êtes pas authentifié");
      }

      final response = await http.post(
        Uri.parse('$apiUrl/docker/containers/$id/restart'),
        headers: <String, String>{'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return ApiResponse(success: true, data: jsonDecode(response.body));
      } else {
        return ApiResponse(success: false,
            errorMessage: "Erreur de récupération des données. Code erreur ${response
                .statusCode}");
      }
    } catch (e) {
      return ApiResponse(
          success: false, errorMessage: "Erreur de réseau ou serveur");
    }
  }

  Future<ApiResponse> killContainer(String id) async {
    try {
      String? token = await authService.getToken();
      if (token == null) {
        return ApiResponse(
            success: false, errorMessage: "Vous n'êtes pas authentifié");
      }

      final response = await http.post(
        Uri.parse('$apiUrl/docker/containers/$id/kill'),
        headers: <String, String>{'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return ApiResponse(success: true, data: jsonDecode(response.body));
      } else {
        return ApiResponse(success: false,
            errorMessage: "Erreur de récupération des données. Code erreur ${response.statusCode}");
      }
    } catch (e) {
      return ApiResponse(
          success: false, errorMessage: "Erreur de réseau ou serveur");
    }
  }

  Future<ApiResponse> sendCommand(String id, String command) async {
    try {
      String? token = await authService.getToken();
      if (token == null) {
        return ApiResponse(
            success: false, errorMessage: "Vous n'êtes pas authentifié");
      }

      final response = await http.post(
        Uri.parse('$apiUrl/docker/containers/$id/command'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'command': command,
        }),
      );

      if (response.statusCode == 200) {
        return ApiResponse(success: true);
      } else {
        return ApiResponse(success: false,
            errorMessage: "Erreur de récupération des données. Code erreur ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      return ApiResponse(
          success: false, errorMessage: "Erreur de réseau ou serveur");
    }
  }
}
