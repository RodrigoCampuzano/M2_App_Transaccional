// ============================================================
// api_response.dart - Wrapper genérico para respuestas de la API
// Encapsula éxito/error de las llamadas HTTP
// ============================================================

/// Clase genérica que envuelve las respuestas de la API.
/// Permite manejar éxito y error de forma consistente.
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int statusCode;

  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    required this.statusCode,
  });

  /// Constructor para respuestas exitosas
  factory ApiResponse.success({
    required T data,
    String? message,
    int statusCode = 200,
  }) {
    return ApiResponse(
      success: true,
      data: data,
      message: message,
      statusCode: statusCode,
    );
  }

  /// Constructor para respuestas con error
  factory ApiResponse.error({
    required String message,
    int statusCode = 500,
  }) {
    return ApiResponse(
      success: false,
      message: message,
      statusCode: statusCode,
    );
  }
}
