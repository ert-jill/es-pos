import 'package:get/get.dart';
import 'package:pos/screens/login.dart';
import 'package:pos/screens/start.dart';
import 'package:pos/services/auth_guard.dart';

import 'screens/select_account.dart';
import 'services/account_guard.dart';

class RouteNames {
  static const login = '/login';
  static const start = '/start';
  // static const select_account = '/selectaccount';
}

class AppPages {
  AppPages._();
  static const initial = RouteNames.login;

  static final routes = [
    GetPage(
      name: RouteNames.login,
      page: () => LoginScreen(),
    ),
    // GetPage(
    //     name: RouteNames.select_account,
    //     page: () => SelectAccountScreen(),
    //     middlewares: [AuthGuard(), AccountGuard()]),
    GetPage(
        name: RouteNames.start,
        page: () => StartScreen(),
        middlewares: [AuthGuard()]),
  ];
}

class AuthConstant {
  static const user = 'abc';
  static const user_details = 'bcd';
  // static const user_selected_account = 'cde';
}
