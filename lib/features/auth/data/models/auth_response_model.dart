// ============================================================
// auth_response_model.dart - Modelo de respuesta de autenticación
// Contiene el usuario y el token JWT
// ============================================================

import 'user_model.dart';

/// Modelo que encapsula la respuesta de login/register.
/// Contiene los datos del usuario autenticado y su token JWT.
class AuthResponseModel {
  final UserModel user;
  final String token;

  const AuthResponseModel({
    required this.user,
    required this.token,
  });

  /// Crea una instancia desde el JSON de la API
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
    );
  }

  @override
  String toString() => 'AuthResponseModel(user: $user, token: $token)';
}
