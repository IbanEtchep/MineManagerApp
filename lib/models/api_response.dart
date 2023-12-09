class ApiResponse {
  final bool success;
  final dynamic data;
  final String? errorMessage;

  ApiResponse({required this.success, this.data, this.errorMessage});
}
