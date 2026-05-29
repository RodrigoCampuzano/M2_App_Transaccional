class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException({required this.message, this.statusCode});

  @override
  String toString() => 'ApiException: $message (code: $statusCode)';
}

class AuthException implements Exception {
  final String message;

  const AuthException({required this.message});

  @override
  String toString() => 'AuthException: $message';
}

class NetworkException implements Exception {
  final String message;

  const NetworkException({this.message = 'Error de conexión a internet'});

  @override
  String toString() => 'NetworkException: $message';
}
