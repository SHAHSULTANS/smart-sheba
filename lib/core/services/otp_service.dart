
// lib/core/services/otp_service.dart
import 'dart:async';
import 'dart:math';

class OtpService {
  static final Map<String, OtpData> _otpStorage = {};
  static const int _otpValidityMinutes = 5;
  static const int _maxAttempts = 3;
  static const int _resendCooldownSeconds = 60;

  // Generate and store OTP
  static Future<String> generateOtp(String phoneNumber) async {
    // Generate random 6-digit OTP
    final random = Random();
    final otp = (100000 + random.nextInt(900000)).toString();
    
    // Store OTP with metadata
    _otpStorage[phoneNumber] = OtpData(
      code: otp,
      generatedAt: DateTime.now(),
      attempts: 0,
      phoneNumber: phoneNumber,
    );
    
    // Auto-expire OTP after validity period
    Timer(Duration(minutes: _otpValidityMinutes), () {
      _otpStorage.remove(phoneNumber);
    });
    
    // In development, log the OTP
    print('Generated OTP for $phoneNumber: $otp');
    
    return otp;
  }

  // Verify OTP
  static Future<OtpVerificationResult> verifyOtp(
      String phoneNumber, String enteredOtp) async {
    final otpData = _otpStorage[phoneNumber];
    
    if (otpData == null) {
      return OtpVerificationResult(
        success: false,
        error: OtpError.expired,
        message: 'OTP এক্সপায়ার হয়ে গেছে। নতুন OTP চান।',
      );
    }

    // Check if OTP is expired
    if (DateTime.now().difference(otpData.generatedAt).inMinutes >= 
        _otpValidityMinutes) {
      _otpStorage.remove(phoneNumber);
      return OtpVerificationResult(
        success: false,
        error: OtpError.expired,
        message: 'OTP এক্সপায়ার হয়ে গেছে। নতুন OTP চান।',
      );
    }

    // Check attempts limit
    if (otpData.attempts >= _maxAttempts) {
      _otpStorage.remove(phoneNumber);
      return OtpVerificationResult(
        success: false,
        error: OtpError.maxAttemptsReached,
        message: 'অনেকবার ভুল চেষ্টা। নতুন OTP চান।',
      );
    }

    // Increment attempts
    otpData.attempts++;

    // Verify OTP
    if (otpData.code == enteredOtp) {
      _otpStorage.remove(phoneNumber);
      return OtpVerificationResult(
        success: true,
        message: 'OTP সফলভাবে যাচাই হয়েছে।',
      );
    } else {
      return OtpVerificationResult(
        success: false,
        error: OtpError.invalid,
        message: 'ভুল OTP। আবার চেষ্টা করুন। (${_maxAttempts - otpData.attempts} বার চেষ্টা বাকি)',
      );
    }
  }

  // Check if can resend OTP
  static Future<bool> canResendOtp(String phoneNumber) async {
    final otpData = _otpStorage[phoneNumber];
    if (otpData == null) return true;
    
    final timeSinceGenerated = DateTime.now().difference(otpData.generatedAt);
    return timeSinceGenerated.inSeconds >= _resendCooldownSeconds;
  }

  // Get remaining resend cooldown
  static Future<int> getResendCooldown(String phoneNumber) async {
    final otpData = _otpStorage[phoneNumber];
    if (otpData == null) return 0;
    
    final timeSinceGenerated = DateTime.now().difference(otpData.generatedAt);
    final remaining = _resendCooldownSeconds - timeSinceGenerated.inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  // Get OTP info for debugging
  static OtpData? getOtpData(String phoneNumber) {
    return _otpStorage[phoneNumber];
  }

  // Clear expired OTPs manually
  static void clearExpiredOtps() {
    final now = DateTime.now();
    _otpStorage.removeWhere((key, value) => 
      now.difference(value.generatedAt).inMinutes >= _otpValidityMinutes);
  }
}

class OtpData {
  final String code;
  final DateTime generatedAt;
  int attempts;
  final String phoneNumber;

  OtpData({
    required this.code,
    required this.generatedAt,
    required this.attempts,
    required this.phoneNumber,
  });
}

class OtpVerificationResult {
  final bool success;
  final OtpError? error;
  final String message;

  OtpVerificationResult({
    required this.success,
    this.error,
    required this.message,
  });
}

enum OtpError {
  invalid,
  expired,
  maxAttemptsReached,
  networkError,
  serverError,
}
