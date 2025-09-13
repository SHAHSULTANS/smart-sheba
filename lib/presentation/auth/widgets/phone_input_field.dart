// lib/presentation/auth/widgets/phone_input_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const PhoneInputField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
        _BangladeshPhoneFormatter(),
      ],
      decoration: InputDecoration(
        labelText: 'মোবাইল নম্বর',
        hintText: '১৭xxxxxxxx',
        prefixIcon: const Icon(Icons.phone),
        prefixText: '+880 ',
        prefixStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'মোবাইল নম্বর প্রয়োজন';
        }
        if (value.length != 10) {
          return 'সঠিক মোবাইল নম্বর দিন';
        }
        if (!value.startsWith('1')) {
          return 'বাংলাদেশি নম্বর দিন';
        }
        return null;
      },
      onChanged: onChanged,
    );
  }
}

class _BangladeshPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    
    // Auto-complete first digit as 1 if user starts typing
    if (text.length == 1 && text != '1') {
      return TextEditingValue(
        text: '1$text',
        selection: TextSelection.collapsed(offset: 2),
      );
    }
    
    return newValue;
  }
}
