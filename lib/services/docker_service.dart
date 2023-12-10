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
        return ApiResponse(success: false, errorMessage: "Vous n'êtes pas authentifié");
      }

      final response = await http.get(
        Uri.parse('$apiUrl/docker/containers'),
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

}