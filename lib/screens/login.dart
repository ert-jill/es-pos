import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/constant.dart';
import 'package:pos/services/loading_service.dart';
import 'package:pos/services/snack_bar_service.dart';
import '../models/credential.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../services/user_service.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final AuthService authService = Get.find<AuthService>();
  final UserService userService = Get.find<UserService>();
  final StorageService storageService = Get.find<StorageService>();
  RxBool loading = true.obs;
  RxBool loggingIn = false.obs;
  LoadingService loadingService = LoadingService();

  onInit() async {
    await authService.checkLogged();
    loading.value = false;
  }

  handleLogin() async {
    if (loggingIn.value) {
      return;
    }
    loggingIn.value = true;
    loadingService.presentLoading();
    var credentials =
        LoginCredentials(userController.text, passwordController.text);
    var result = await authService.login(credentials);

    if (result.isOk == true) {
      await userService.getUserDetails();
      loadingService.dismissLoading();
      Get.offAndToNamed(RouteNames.start);
    } else {
      loadingService.dismissLoading();
      if ((result.statusCode ?? 0) >= 400 && (result.statusCode ?? 0) <= 500) {
        SnackBarService.presentSnackBar(
            'Error', result.body['detail'], AlertType.error);
      }
    }
    loggingIn.value = false;
  }

  @override
  Widget build(BuildContext context) {
    onInit();
    return Obx(() => loading.value
        ? SizedBox()
        : Scaffold(
            // appBar: AppBar(
            //   title: Text('Login Screen'),
            // ),
            body: Center(
              child: Container(
                width: 400,
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 16),
                          child: TextFormField(
                            onFieldSubmitted: (text) {
                              handleLogin();
                            },
                            controller: userController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Username/Email"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username/email';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 16),
                          child: TextFormField(
                            onFieldSubmitted: (text) {
                              handleLogin();
                            },
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Password"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: !loggingIn.value
                                ? () {
                                    handleLogin();
                                  }
                                : null,
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: const Text('Login'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ));
  }
}
