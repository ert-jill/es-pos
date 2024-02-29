import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/constant.dart';
import 'package:pos/services/product_service.dart';
import 'package:pos/services/storage_service.dart';
import 'package:pos/services/user_service.dart';

import 'services/auth_service.dart';
import 'services/http_service.dart';

void main() {
  // Initialize GetX services
  Get.put(StorageService());
  Get.put(HttpService('http://127.0.0.1:8000/api/'));
  Get.put(AuthService());
  Get.put(UserService());
  Get.put(ProductService());

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'POS',
      debugShowCheckedModeBanner: false,
      // unknownRoute: AppPages.routes[0],
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
