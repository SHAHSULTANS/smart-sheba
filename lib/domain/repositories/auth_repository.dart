import '../entities/user.dart';

abstract class AuthRepository {
  Future<void> sendOtp(String phoneNumber);
  Future<User> verifyOtpAndLogin(String phoneNumber, String otp);
  Future<User?> getCurrentUser();
  Future<void> logout();
  Future<bool> isLoggedIn();
}