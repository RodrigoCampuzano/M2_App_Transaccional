// ============================================================
// api_constants.dart - Constantes de la API
// Centraliza las URLs y endpoints del backend
// ============================================================

/// Constantes de configuración de la API REST.
/// Cambiar [baseUrl] según el entorno (local, staging, producción).
class ApiConstants {
  // Para emulador Android: 10.0.2.2
  // Para dispositivo físico: IP de tu máquina en la red local
  // Para web/desktop: localhost
  static const String baseUrl = 'http://10.0.2.2:3000';

  // Endpoints de autenticación
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String profile = '/api/auth/profile';

  // Endpoints de productos
  static const String products = '/api/products';

  /// Retorna la URL completa para un producto específico
  static String productById(int id) => '/api/products/$id';
}
