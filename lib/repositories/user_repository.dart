import '../models/user.dart';
import '../services/auth_service.dart';

class UserRepository {
  final AuthService _authService;

  UserRepository({required AuthService authService}) : _authService = authService;

  Future<User> login(String email, String password) async {
    final response = await _authService.login(email, password);
    if (response.success) {
      return await getUser();
    }else {
      throw Exception(response.errorMessage);
    }
  }

  Future<User> register(String email, String username, String password) async {
    final response = await _authService.register(email, username, password);
    if (response.success) {
      return await login(email, password);
    } else {
      throw Exception(response.errorMessage);
    }
  }

  Future<void> logout() async {
    await _authService.logout();
  }

  Future<User> getUser() async {
    final response = await _authService.getUserDetails();
    if (response.success) {
      return User.fromJson(response.data);
    } else {
      throw Exception(response.errorMessage);
    }
  }
}
