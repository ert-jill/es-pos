// auth_guard.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/constant.dart';
import 'user_service.dart';

class AccountGuard extends GetMiddleware {
  final UserService _userService = Get.find();

  @override
  RouteSettings? redirect(String? route) {
    // if (route == RouteNames.select_account &&
    //     _userService.userSelectedAccount.value != null) {
    //   Get.off(RouteNames.start);
    // }
    // if (_userService.userSelectedAccount.value == null &&
    //     route != RouteNames.select_account) {
    //   // Redirect to login screen if not authenticated
    //   Get.off(RouteNames.select_account);
    //   return null; // Return null to indicate navigation handled
    // }
    // Allow navigation to the intended screen
    return null;
  }
}
