import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';
import '../errors/exceptions.dart';

class ApiClient {
  final http.Client _client;
  String? _token;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  void setToken(String? token) {
    _token = token;
  }

  String? get token => _token;
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

  Uri _buildUri(String endpoint, {Map<String, String>? queryParams}) {
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams);
    }
    return uri;
  }

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

  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final uri = _buildUri(endpoint);
      final response = await _client.delete(uri, headers: _headers);
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final status = response.statusCode;

    if (status == 200 || status == 201) {
      return body;
    }

    final message = switch (status) {
      400 => body['message'] ?? 'Solicitud inválida',
      401 => body['message'] ?? 'No autorizado',
      403 => body['message'] ?? 'Acceso denegado',
      404 => body['message'] ?? 'Recurso no encontrado',
      409 => body['message'] ?? 'Conflicto - El recurso ya existe',
      _ => body['message'] ?? 'Error del servidor',
    };
    throw ApiException(message: message, statusCode: status);
  }

  Exception _handleError(dynamic error) {
    if (error is ApiException) {
      return error;
    }
    return const NetworkException();
  }

  void dispose() {
    _client.close();
  }
}
