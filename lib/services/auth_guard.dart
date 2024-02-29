// auth_guard.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/services/auth_service.dart';

import '../constant.dart';

class AuthGuard extends GetMiddleware {
  final AuthService _authService = Get.find();

  @override
  RouteSettings? redirect(String? route) {
    if (route == '/login' && _authService.access.value != '') {
      print(route);
      Get.off(RouteNames.start);
      return null;
    }

    if (_authService.access.value == '' && route != '/login') {
      // Redirect to login screen if not authenticated
      return const RouteSettings(name: '/login');
    }

    // Allow navigation to the intended screen
    return null;
  }
}
