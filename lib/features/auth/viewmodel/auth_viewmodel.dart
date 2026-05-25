// ============================================================
// auth_viewmodel.dart - ViewModel de autenticación (MVVM)
// Gestiona el estado de autenticación con ChangeNotifier
// ============================================================

import 'package:flutter/foundation.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';
import '../../../../core/network/api_client.dart';

/// ViewModel que gestiona el estado de autenticación.
/// Implementa [ChangeNotifier] para notificar cambios a la UI.
/// 
/// Responsabilidades:
/// - Login y registro de usuarios
/// - Manejo del estado de carga y errores
/// - Almacenar la sesión del usuario actual
class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository;
  final ApiClient _apiClient;

  // Estado
  UserModel? _user;
  String? _token;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  // Getters - Exponen el estado de forma reactiva
  UserModel? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  AuthViewModel({
    required AuthRepository repository,
    required ApiClient apiClient,
  })  : _repository = repository,
        _apiClient = apiClient;

  // ============================================================
  // Login - Iniciar sesión
  // ============================================================
  /// Intenta iniciar sesión con las credenciales proporcionadas.
  /// Actualiza el estado reactivamente para que la UI se actualice.
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final authResponse = await _repository.login(
        email: email,
        password: password,
      );

      _user = authResponse.user;
      _token = authResponse.token;
      _isAuthenticated = true;

      // Establecer el token en el ApiClient para futuras peticiones
      _apiClient.setToken(_token);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(_parseError(e));
      _setLoading(false);
      return false;
    }
  }

  // ============================================================
  // Register - Registrar usuario
  // ============================================================
  /// Registra un nuevo usuario en el sistema.
  /// Si el registro es exitoso, inicia sesión automáticamente.
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final authResponse = await _repository.register(
        name: name,
        email: email,
        password: password,
      );

      _user = authResponse.user;
      _token = authResponse.token;
      _isAuthenticated = true;

      // Establecer el token en el ApiClient
      _apiClient.setToken(_token);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(_parseError(e));
      _setLoading(false);
      return false;
    }
  }

  // ============================================================
  // Logout - Cerrar sesión
  // ============================================================
  /// Cierra la sesión del usuario actual.
  /// Limpia todos los datos de autenticación.
  void logout() {
    _user = null;
    _token = null;
    _isAuthenticated = false;
    _apiClient.setToken(null);
    notifyListeners();
  }

  // ============================================================
  // Helpers privados
  // ============================================================

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  /// Extrae un mensaje legible del error
  String _parseError(dynamic error) {
    final message = error.toString();
    // Remover el prefijo "Exception: " si existe
    if (message.startsWith('Exception: ')) {
      return message.substring(11);
    }
    return message;
  }
}
