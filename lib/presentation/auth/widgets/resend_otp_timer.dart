// lib/presentation/auth/widgets/resend_otp_timer.dart
import 'package:flutter/material.dart';
import 'dart:async';

class ResendOtpTimer extends StatefulWidget {
  final int initialSeconds;
  final VoidCallback onResend;
  final bool enabled;

  const ResendOtpTimer({
    super.key,
    this.initialSeconds = 60,
    required this.onResend,
    this.enabled = true,
  });

  @override
  State<ResendOtpTimer> createState() => _ResendOtpTimerState();
}

class _ResendOtpTimerState extends State<ResendOtpTimer> {
  late int _secondsRemaining;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.initialSeconds;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _canResend = false;
    _secondsRemaining = widget.initialSeconds;
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
          } else {
            _canResend = true;
            timer.cancel();
          }
        });
      }
    });
  }

  void _handleResend() {
    if (_canResend && widget.enabled) {
      widget.onResend();
      _startTimer();
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!_canResend) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.timer,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              const SizedBox(width: 4),
              Text(
                'পুনরায় OTP পাঠাতে ${_formatTime(_secondsRemaining)} অপেক্ষা করুন',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ] else ...[
          TextButton.icon(
            onPressed: widget.enabled ? _handleResend : null,
            icon: const Icon(Icons.refresh),
            label: const Text('OTP পুনরায় পাঠান'),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ],
    );
  }

  void reset() {
    _timer?.cancel();
    _startTimer();
  }
}