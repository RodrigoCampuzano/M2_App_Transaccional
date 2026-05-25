// ============================================================
// user_model.dart - Modelo de usuario
// Representación del usuario con serialización JSON
// ============================================================

/// Modelo que representa un usuario del sistema.
/// Incluye métodos de serialización para comunicación con la API.
class UserModel {
  final int? id;
  final String name;
  final String email;
  final String? createdAt;

  const UserModel({
    this.id,
    required this.name,
    required this.email,
    this.createdAt,
  });

  /// Crea una instancia de [UserModel] desde un Map JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      createdAt: json['created_at'] as String?,
    );
  }

  /// Convierte el modelo a un Map JSON para enviar a la API
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
    };
  }

  /// Crea una copia del modelo con campos actualizados
  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() => 'UserModel(id: $id, name: $name, email: $email)';
}
