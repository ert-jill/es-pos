import 'package:flutter/services.dart';

class AmountInputFormatter extends TextInputFormatter {
  // Allows only price format (e.g., 0.00, 1.50, 100.00)
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final regEx = RegExp(r'^\d*\.?\d{0,2}$');
    if (regEx.hasMatch(newValue.text)) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}
