// ============================================================
// exceptions.dart - Excepciones personalizadas de la aplicación
// ============================================================

/// Excepción para errores de la API
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException({required this.message, this.statusCode});

  @override
  String toString() => 'ApiException: $message (code: $statusCode)';
}

/// Excepción para errores de autenticación
class AuthException implements Exception {
  final String message;

  const AuthException({required this.message});

  @override
  String toString() => 'AuthException: $message';
}

/// Excepción para errores de red/conexión
class NetworkException implements Exception {
  final String message;

  const NetworkException({this.message = 'Error de conexión a internet'});

  @override
  String toString() => 'NetworkException: $message';
}
