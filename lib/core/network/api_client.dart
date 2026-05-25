// ============================================================
// api_client.dart - Cliente HTTP centralizado
// Encapsula todas las llamadas HTTP (GET, POST, PUT, DELETE)
// usando el paquete http con manejo de errores y headers
// ============================================================

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

/// Cliente HTTP reutilizable que encapsula los métodos
/// GET, POST, PUT y DELETE con manejo de headers y errores.
class ApiClient {
  final http.Client _client;
  String? _token;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  /// Establece el token JWT para las peticiones autenticadas
  void setToken(String? token) {
    _token = token;
  }

  /// Obtiene el token actual
  String? get token => _token;

  /// Headers comunes para todas las peticiones
  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  /// Construye la URI completa a partir del endpoint
  Uri _buildUri(String endpoint, {Map<String, String>? queryParams}) {
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams);
    }
    return uri;
  }

  // ============================================================
  // GET - Obtener recursos
  // ============================================================
  /// Realiza una petición GET al endpoint especificado.
  /// 
  /// [endpoint] - Ruta del recurso (ej: '/api/products')
  /// [queryParams] - Parámetros de consulta opcionales
  /// 
  /// Retorna un Map con la respuesta parseada del JSON.
  /// Lanza [Exception] si el status code no es exitoso.
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParams,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParams: queryParams);
      final response = await _client.get(uri, headers: _headers);
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ============================================================
  // POST - Crear recursos
  // ============================================================
  /// Realiza una petición POST al endpoint especificado.
  /// 
  /// [endpoint] - Ruta del recurso (ej: '/api/auth/login')
  /// [body] - Cuerpo de la petición como Map
  /// 
  /// Retorna un Map con la respuesta parseada del JSON.
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      final response = await _client.post(
        uri,
        headers: _headers,
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ============================================================
  // PUT - Actualizar recursos
  // ============================================================
  /// Realiza una petición PUT al endpoint especificado.
  /// 
  /// [endpoint] - Ruta del recurso (ej: '/api/products/1')
  /// [body] - Cuerpo de la petición con los datos actualizados
  /// 
  /// Retorna un Map con la respuesta parseada del JSON.
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      final response = await _client.put(
        uri,
        headers: _headers,
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ============================================================
  // DELETE - Eliminar recursos
  // ============================================================
  /// Realiza una petición DELETE al endpoint especificado.
  /// 
  /// [endpoint] - Ruta del recurso (ej: '/api/products/1')
  /// 
  /// Retorna un Map con la respuesta parseada del JSON.
  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final uri = _buildUri(endpoint);
      final response = await _client.delete(uri, headers: _headers);
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ============================================================
  // Manejo de respuestas y errores
  // ============================================================

  /// Procesa la respuesta HTTP y retorna el body como Map.
  /// Lanza excepciones según el status code recibido.
  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = jsonDecode(response.body) as Map<String, dynamic>;

    switch (response.statusCode) {
      case 200:
      case 201:
        return body;
      case 400:
        throw Exception(body['message'] ?? 'Solicitud inválida');
      case 401:
        throw Exception(body['message'] ?? 'No autorizado');
      case 403:
        throw Exception(body['message'] ?? 'Acceso denegado');
      case 404:
        throw Exception(body['message'] ?? 'Recurso no encontrado');
      case 409:
        throw Exception(body['message'] ?? 'Conflicto - El recurso ya existe');
      case 500:
      default:
        throw Exception(body['message'] ?? 'Error del servidor');
    }
  }

  /// Convierte errores de red en excepciones legibles
  Exception _handleError(dynamic error) {
    if (error is Exception) {
      return error;
    }
    return Exception('Error de conexión. Verifica tu internet.');
  }

  /// Libera los recursos del cliente HTTP
  void dispose() {
    _client.close();
  }
}
