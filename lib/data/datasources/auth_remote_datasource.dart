import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> sendOtp(String phoneNumber);
  Future<UserModel> verifyOtpAndLogin(String phoneNumber, String otp);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<void> sendOtp(String phoneNumber) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConstants.baseUrl}/auth/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phoneNumber': phoneNumber}),
      );

      if (response.statusCode != 200) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> verifyOtpAndLogin(String phoneNumber, String otp) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConstants.baseUrl}/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phoneNumber': phoneNumber,
          'otp': otp,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return UserModel.fromJson(responseBody['data']);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}

// MOCK IMPLEMENTATION FOR DEVELOPMENT
class AuthRemoteDataSourceMock implements AuthRemoteDataSource {
  @override
  Future<void> sendOtp(String phoneNumber) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Validate phone number format
    if (!phoneNumber.startsWith('+880')) {
      throw ServerException();
    }
    
    // Mock success - in real implementation this would send actual OTP
    print('Mock OTP sent to $phoneNumber');
    return;
  }

  @override
  Future<UserModel> verifyOtpAndLogin(String phoneNumber, String otp) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Mock OTP validation - accept any 6 digit code or "123456"
    if (otp.length != 6) {
      throw ServerException();
    }
    
    // Create mock user data
    final mockUserData = {
      'id': 'mock-user-123',
      'phoneNumber': phoneNumber,
      'email': null,
      'name': 'Test User',
      'avatar': null,
      'role': 'customer',
      'isVerified': true,
      'createdAt': DateTime.now().toIso8601String(),
      'lastLoginAt': DateTime.now().toIso8601String(),
      'token': 'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}',
    };
    
    return UserModel.fromJson(mockUserData);
  }
}