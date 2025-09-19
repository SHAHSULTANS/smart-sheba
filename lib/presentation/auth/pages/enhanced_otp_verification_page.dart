import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth_bloc.dart';
import '../widgets/enhanced_otp_input.dart';
import '../widgets/resend_otp_timer.dart';
import '../../common/widgets/loading_button.dart';
import '../../../core/services/otp_service.dart';
import '../../../core/utils/validators.dart';

class EnhancedOtpVerificationPage extends StatefulWidget {
  final String phoneNumber;

  const EnhancedOtpVerificationPage({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<EnhancedOtpVerificationPage> createState() => _EnhancedOtpVerificationPageState();
}

class _EnhancedOtpVerificationPageState extends State<EnhancedOtpVerificationPage> {
  final GlobalKey<EnhancedOtpInputState> _otpInputKey = GlobalKey();
  String _otpCode = '';
  bool _isLoading = false;
  String? _otpError;
  bool _isOtpComplete = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP যাচাই'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        elevation: 0,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          setState(() => _isLoading = state is AuthLoading);

          if (state is AuthAuthenticated) {
            context.goNamed('home');
          } else if (state is AuthError) {
            setState(() => _otpError = state.message);
            _showErrorSnackBar(state.message);
          } else if (state is AuthOtpSent) {
            _showSuccessSnackBar('OTP পুনরায় পাঠানো হয়েছে');
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                
                // Header icon
                _buildHeaderIcon(),
                
                const SizedBox(height: 32),
                
                // Title and description
                _buildTitleSection(),
                
                const SizedBox(height: 40),
                
                // OTP Input
                EnhancedOtpInput(
                  key: _otpInputKey,
                  onChanged: _handleOtpChanged,
                  onCompleted: _handleOtpCompleted,
                  enabled: !_isLoading,
                  errorText: _otpError,
                ),
                
                const SizedBox(height: 32),
                
                // Verify button
                LoadingButton(
                  onPressed: _canVerify() && !_isLoading ? _handleVerifyOtp : null,
                  isLoading: _isLoading,
                  child: const Text('যাচাই করুন'),
                ),
                
                const SizedBox(height: 24),
                
                // Resend timer
                ResendOtpTimer(
                  onResend: _handleResendOtp,
                  enabled: !_isLoading,
                ),
                
                const SizedBox(height: 32),
                
                // Development info (for testing)
                if (_isDebugMode()) _buildDebugInfo(),
                
                const SizedBox(height: 20),
                
                // Help section
                _buildHelpSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderIcon() {
    return Center(
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: Icon(
          Icons.sms_outlined,
          size: 40,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      children: [
        Text(
          'OTP যাচাই করুন',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          '${Validators.formatBangladeshiPhone(widget.phoneNumber)} নম্বরে পাঠানো ৬ সংখ্যার কোড প্রবেশ করুন',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDebugInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.developer_mode, size: 16, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                'ডেভেলপমেন্ট মোড',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '• যেকোনো ৬ সংখ্যার কোড ব্যবহার করুন\n• উদাহরণ: 123456 বা 000000',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.blue.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection() {
    return Column(
      children: [
        Text(
          'OTP পাননি?',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            TextButton(
              onPressed: () => _showTroubleshootDialog(),
              child: const Text('সমস্যা সমাধান'),
            ),
            TextButton(
              onPressed: () => _showSupportDialog(),
              child: const Text('সাপোর্ট'),
            ),
          ],
        ),
      ],
    );
  }

  void _handleOtpChanged(String otp) {
    setState(() {
      _otpCode = otp;
      _isOtpComplete = otp.length == 6;
      if (_otpError != null) {
        _otpError = null;
      }
    });
  }

  void _handleOtpCompleted(String otp) {
    _handleVerifyOtp();
  }

  bool _canVerify() {
    return _isOtpComplete && Validators.isValidOtp(_otpCode);
  }

  void _handleVerifyOtp() {
    if (_canVerify()) {
      context.read<AuthBloc>().add(
        VerifyOtpEvent(
          phoneNumber: widget.phoneNumber,
          otp: _otpCode,
        ),
      );
    }
  }

  void _handleResendOtp() {
    setState(() => _otpError = null);
    _otpInputKey.currentState?.clearOtp();
    
    context.read<AuthBloc>().add(
      LoginEvent(phoneNumber: widget.phoneNumber),
    );
  }

  bool _isDebugMode() {
    // In production, this should return false
    return true; // Set to false for production
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showTroubleshootDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('সমস্যা সমাধান'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• নেটওয়ার্ক সংযোগ পরীক্ষা করুন'),
            Text('• স্প্যাম ফোল্ডার দেখুন'),
            Text('• কিছুক্ষণ অপেক্ষা করুন'),
            Text('• ফোন নম্বর সঠিক কিনা যাচাই করুন'),
            Text('• OTP পুনরায় পাঠানোর চেষ্টা করুন'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('বুঝেছি'),
          ),
        ],
      ),
    );
  }

  void _showSupportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('সাপোর্ট'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('আমাদের সাথে যোগাযোগ করুন:'),
            SizedBox(height: 12),
            Text('📞 হটলাইন: ১৬২৬ৣ'),
            Text('📧 ইমেইল: support@smartsheba.com'),
            Text('🕒 সেবা সময়: ২৪/৭'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ঠিক আছে'),
          ),
        ],
      ),
    );
  }
}