
// lib/data/datasources/auth_local_datasource.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearCachedUser();
  Future<String?> getAuthToken();
  Future<void> saveAuthToken(String token);
  Future<void> clearAuthToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  static const String _userKey = 'CACHED_USER';
  static const String _tokenKey = 'AUTH_TOKEN';

  @override
  Future<UserModel?> getCachedUser() async {
    final userString = sharedPreferences.getString(_userKey);
    if (userString != null) {
      return UserModel.fromJson(jsonDecode(userString));
    }
    return null;
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await sharedPreferences.setString(
      _userKey,
      jsonEncode(user.toJson()),
    );
  }

  @override
  Future<void> clearCachedUser() async {
    await sharedPreferences.remove(_userKey);
  }

  @override
  Future<String?> getAuthToken() async {
    return sharedPreferences.getString(_tokenKey);
  }

  @override
  Future<void> saveAuthToken(String token) async {
    await sharedPreferences.setString(_tokenKey, token);
  }

  @override
  Future<void> clearAuthToken() async {
    await sharedPreferences.remove(_tokenKey);
  }
}
