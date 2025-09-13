import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class AuthUsecases {
  final AuthRepository _authRepository;

  AuthUsecases({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Future<void> sendOtp(String phoneNumber) async {
    return await _authRepository.sendOtp(phoneNumber);
  }

  Future<User> verifyOtpAndLogin(String phoneNumber, String otp) async {
    return await _authRepository.verifyOtpAndLogin(phoneNumber, otp);
  }

  Future<User?> getCurrentUser() async {
    return await _authRepository.getCurrentUser();
  }

  Future<void> logout() async {
    return await _authRepository.logout();
  }

  Future<bool> isLoggedIn() async {
    return await _authRepository.isLoggedIn();
  }
}