import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AlertType {
  warning,
  success,
  error,
}

class SnackBarService {
  static presentSnackBar(String title, String message, AlertType type) {
    Get.snackbar(
      title,
      message,
      duration: Duration(seconds: 2),
      backgroundColor: type == AlertType.error
          ? Colors.red
          : type == AlertType.warning
              ? Colors.amber
              : Colors.green,
      colorText: Colors.white,
    );
  }
}
