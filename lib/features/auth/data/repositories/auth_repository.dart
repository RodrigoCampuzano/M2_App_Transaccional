// ============================================================
// auth_repository.dart - Repositorio de autenticación
// Accede a la API para login, register y perfil
// ============================================================

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

/// Repositorio que encapsula las operaciones de autenticación.
/// Se comunica con la API a través del [ApiClient].
class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  /// Registra un nuevo usuario en el sistema.
  /// 
  /// Realiza un POST a /api/auth/register con los datos del usuario.
  /// Retorna un [AuthResponseModel] con el usuario creado y su token.
  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.register,
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    return AuthResponseModel.fromJson(response['data']);
  }

  /// Inicia sesión con email y contraseña.
  /// 
  /// Realiza un POST a /api/auth/login.
  /// Retorna un [AuthResponseModel] con el usuario y su token.
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.login,
      body: {
        'email': email,
        'password': password,
      },
    );

    return AuthResponseModel.fromJson(response['data']);
  }

  /// Obtiene el perfil del usuario autenticado.
  /// 
  /// Realiza un GET a /api/auth/profile (requiere token).
  /// Retorna un [UserModel] con los datos del perfil.
  Future<UserModel> getProfile() async {
    final response = await _apiClient.get(ApiConstants.profile);
    return UserModel.fromJson(response['data']['user']);
  }
}
