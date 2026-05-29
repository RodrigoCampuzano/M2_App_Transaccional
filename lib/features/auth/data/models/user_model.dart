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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {if (id != null) 'id': id, 'name': name, 'email': email};
  }

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
