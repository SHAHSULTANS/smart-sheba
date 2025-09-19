// lib/presentation/auth/widgets/enhanced_phone_input_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/utils/validators.dart';

class EnhancedPhoneInputField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final bool enabled;

  const EnhancedPhoneInputField({
    super.key,
    required this.controller,
    this.onChanged,
    this.errorText,
    this.enabled = true,
  });

  @override
  State<EnhancedPhoneInputField> createState() => _EnhancedPhoneInputFieldState();
}

class _EnhancedPhoneInputFieldState extends State<EnhancedPhoneInputField> {
  String _carrierName = '';
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onPhoneChanged);
    _validatePhone();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onPhoneChanged);
    super.dispose();
  }

  void _onPhoneChanged() {
    _validatePhone();
    widget.onChanged?.call(widget.controller.text);
  }

  void _validatePhone() {
    final phone = widget.controller.text;
    final isValid = Validators.isValidBangladeshiPhone(phone);
    final carrier = isValid ? Validators.getCarrierName(phone) : '';
    
    if (mounted) {
      setState(() {
        _isValid = isValid;
        _carrierName = carrier;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          enabled: widget.enabled,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
            _BangladeshiPhoneFormatter(),
          ],
          decoration: InputDecoration(
            labelText: 'মোবাইল নম্বর',
            hintText: '01XXXXXXXXX',
            prefixIcon: Icon(
              Icons.phone_android,
              color: _isValid 
                ? Theme.of(context).colorScheme.primary 
                : null,
            ),
            prefixText: '+880 ',
            prefixStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            suffixIcon: _isValid
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : widget.controller.text.isNotEmpty
                    ? Icon(
                        Icons.error,
                        color: Theme.of(context).colorScheme.error,
                      )
                    : null,
            errorText: widget.errorText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _isValid 
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _isValid 
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                  : Theme.of(context).colorScheme.outline,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'মোবাইল নম্বর প্রয়োজন';
            }
            if (!Validators.isValidBangladeshiPhone(value)) {
              return 'সঠিক বাংলাদেশি মোবাইল নম্বর দিন';
            }
            return null;
          },
        ),
        
        if (_carrierName.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.sim_card,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                _carrierName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _BangladeshiPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;
    
    // Remove any non-digit characters
    text = text.replaceAll(RegExp(r'[^\d]'), '');
    
    // If user starts typing without 0, prepend it
    if (text.length >= 1 && !text.startsWith('0')) {
      text = '0$text';
    }
    
    // Limit to 11 digits (01XXXXXXXXX format)
    if (text.length > 11) {
      text = text.substring(0, 11);
    }
    
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}