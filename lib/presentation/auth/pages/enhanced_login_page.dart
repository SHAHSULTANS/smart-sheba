// lib/presentation/auth/pages/enhanced_login_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth_bloc.dart';
import '../widgets/enhanced_phone_input_field.dart';
import '../../common/widgets/loading_button.dart';
import '../../../core/utils/validators.dart';

class EnhancedLoginPage extends StatefulWidget {
  const EnhancedLoginPage({super.key});

  @override
  State<EnhancedLoginPage> createState() => _EnhancedLoginPageState();
}

class _EnhancedLoginPageState extends State<EnhancedLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  String? _phoneError;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          setState(() => _isLoading = state is AuthLoading);

          if (state is AuthOtpSent) {
            final fullPhoneNumber = '+880${_phoneController.text}';
            context.pushNamed('otp-verification', extra: fullPhoneNumber);
          } else if (state is AuthError) {
            setState(() => _phoneError = state.message);
            _showErrorSnackBar(state.message);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),

                  // Logo and branding
                  _buildHeader(),

                  const SizedBox(height: 60),

                  // Welcome text
                  Text(
                    'স্বাগতম!',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'আপনার মোবাইল নম্বর দিয়ে শুরু করুন',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  // Phone input field
                  EnhancedPhoneInputField(
                    controller: _phoneController,
                    errorText: _phoneError,
                    enabled: !_isLoading,
                    onChanged: (value) {
                      // Added this to trigger a rebuild and update the button state
                      setState(() {
                        if (_phoneError != null) {
                          _phoneError = null;
                        }
                      });
                    },
                  ),

                  const SizedBox(height: 32),

                  // Send OTP button
                  LoadingButton(
                    onPressed: _canSendOtp() && !_isLoading ? _handleSendOtp : null,
                    isLoading: _isLoading,
                    child: const Text('OTP পাঠান'),
                  ),

                  const SizedBox(height: 24),

                  // Terms and privacy
                  _buildTermsAndPrivacy(),

                  const SizedBox(height: 40),

                  // Help and support
                  _buildHelpSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Utility & UI Builder Methods ---

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.home_repair_service,
            size: 50,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'স্মার্ট শেবা',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'বাংলাদেশের প্রথম AI চালিত সেবা প্ল্যাটফর্ম',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTermsAndPrivacy() {
    return Text.rich(
      TextSpan(
        text: 'এগিয়ে যাওয়ার মাধ্যমে আপনি আমাদের ',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
        children: [
          TextSpan(
            text: 'শর্তাবলী',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w500,
            ),
          ),
          const TextSpan(text: ' এবং '),
          TextSpan(
            text: 'গোপনীয়তা নীতি',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w500,
            ),
          ),
          const TextSpan(text: ' মেনে নিচ্ছেন'),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildHelpSection() {
    return Column(
      children: [
        Text(
          'সাহায্য প্রয়োজন?',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () => _showHelpDialog(),
              icon: const Icon(Icons.help_outline, size: 18),
              label: const Text('সাহায্য'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            TextButton.icon(
              onPressed: () => _showSupportDialog(),
              icon: const Icon(Icons.support_agent, size: 18),
              label: const Text('সাপোর্ট'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- Logic Methods ---

  bool _canSendOtp() {
    final phone = _phoneController.text.trim();
    // print("yes")
    return phone.isNotEmpty && Validators.isValidBangladeshiPhone(phone);
  }

  void _handleSendOtp() {
    // The previous validation logic was incorrect.
    // The button's onPressed property already checks _canSendOtp(),
    // so we don't need to re-validate the form here.
    final phoneNumber = '+880${_phoneController.text}';
    context.read<AuthBloc>().add(LoginEvent(phoneNumber: phoneNumber));
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
        action: SnackBarAction(
          label: 'ঠিক আছে',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('সাহায্য'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• বাংলাদেশি মোবাইল নম্বর ব্যবহার করুন'),
            Text('• নম্বর 01 দিয়ে শুরু হতে হবে'),
            Text('• সর্বমোট ১১ সংখ্যা হতে হবে'),
            Text('• যেমন: 01712345678'),
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
            Text('সাহায্যের জন্য যোগাযোগ করুন:'),
            SizedBox(height: 12),
            Text('📞 হটলাইন: ১৬২৬৩'),
            Text('📧 ইমেইল: support@smartsheba.com'),
            Text('💬 চ্যাট: অ্যাপের মধ্যে'),
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