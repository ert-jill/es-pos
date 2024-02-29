import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/constant.dart';
import 'package:pos/services/user_service.dart';

import '../services/auth_service.dart';

class SelectAccountScreen extends StatelessWidget {
  final AuthService authService = Get.find<AuthService>();
  final UserService userService = Get.find<UserService>();
  RxBool isLoading = false.obs;
  onInit() async {
    isLoading.value = true;
    await userService.getUserAcounts();
    isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    onInit();
    return Scaffold(
        appBar: AppBar(
          title: Text('Accounts'),
          actions: [
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
              ), // More icon
              onSelected: (String choice) {
                // Handle menu item selection here
                if (choice == 'Logout') {
                  authService.logout();
                }
                //else if (choice == 'Item 2') {
                //   // Handle Item 2
                //   print('Reports');
                // }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    padding: EdgeInsets.all(0),
                    value: 'Logout',
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: ListTile(
                        titleAlignment: ListTileTitleAlignment.center,
                        // contentPadding: EdgeInsets.all(0),
                        leading: Icon(
                          Icons.logout_outlined,
                        ),
                        title: Text(
                          'Logout',
                          textAlign: TextAlign.start,
                        ),

                        // horizontalTitleGap: 0,
                        minVerticalPadding: 0,
                      ),
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
        body: Container(
          child: Center(
            child: Container(
              height: double.infinity,
              width: 400,
              child: Column(
                children: [
                  Expanded(
                      child: Obx(() => isLoading.value
                          ? Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              itemCount: userService.userAccounts.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: FilledButton(
                                    onPressed:
                                        userService.userAccounts[index].status
                                            ? () {
                                                userService.selectUserAccount(
                                                    userService
                                                        .userAccounts[index]);
                                              }
                                            : null,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Text(
                                          userService.userAccounts[index].name),
                                    ),
                                  ),
                                );
                              })))
                ],
              ),
            ),
          ),
        ));
  }
}
