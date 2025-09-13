
// lib/data/models/user_model.dart
import '../../domain/entities/user.dart';

class UserModel {
  final String id;
  final String phoneNumber;
  final String? email;
  final String? name;
  final String? avatar;
  final String role;
  final bool isVerified;
  final String createdAt;
  final String? lastLoginAt;
  final String token;

  UserModel({
    required this.id,
    required this.phoneNumber,
    this.email,
    this.name,
    this.avatar,
    required this.role,
    required this.isVerified,
    required this.createdAt,
    this.lastLoginAt,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'],
      name: json['name'],
      avatar: json['avatar'],
      role: json['role'] ?? 'customer',
      isVerified: json['isVerified'] ?? false,
      createdAt: json['createdAt'] ?? '',
      lastLoginAt: json['lastLoginAt'],
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'email': email,
      'name': name,
      'avatar': avatar,
      'role': role,
      'isVerified': isVerified,
      'createdAt': createdAt,
      'lastLoginAt': lastLoginAt,
      'token': token,
    };
  }

  User toEntity() {
    return User(
      id: id,
      phoneNumber: phoneNumber,
      email: email,
      name: name,
      avatar: avatar,
      role: _getUserRole(role),
      isVerified: isVerified,
      createdAt: DateTime.parse(createdAt),
      lastLoginAt: lastLoginAt != null ? DateTime.parse(lastLoginAt!) : null,
    );
  }

  UserRole _getUserRole(String role) {
    switch (role.toLowerCase()) {
      case 'provider':
        return UserRole.provider;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.customer;
    }
  }
}