// lib/domain/entities/user.dart
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String phoneNumber;
  final String? email;
  final String? name;
  final String? avatar;
  final UserRole role;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  const User({
    required this.id,
    required this.phoneNumber,
    this.email,
    this.name,
    this.avatar,
    required this.role,
    required this.isVerified,
    required this.createdAt,
    this.lastLoginAt,
  });

  @override
  List<Object?> get props => [
        id,
        phoneNumber,
        email,
        name,
        avatar,
        role,
        isVerified,
        createdAt,
        lastLoginAt,
      ];

  User copyWith({
    String? id,
    String? phoneNumber,
    String? email,
    String? name,
    String? avatar,
    UserRole? role,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return User(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
}

enum UserRole {
  customer,
  provider,
  admin,
}