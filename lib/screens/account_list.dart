import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../services/account_controller.dart';

class AccountList extends StatelessWidget {
  AccountController accountController;
  RxBool isLoading = false.obs;

  AccountList({super.key, required this.accountController});

  onInit() async {
    isLoading.value = true;
    await accountController.getAccountList();
    isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    onInit();
    return Expanded(
      child: Obx(() => isLoading.value
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: accountController.accountList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.person_outlined),
                        ),
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        onTap: () {},
                        isThreeLine: true,
                        subtitle: Text(
                            '${accountController.accountList[index].email}'),
                        trailing: Text(
                            '${accountController.accountList[index].status}'),
                        title: Text(
                            '${accountController.accountList[index].name ?? ''} ${accountController.accountList[index].contactNumber ?? ''}'),
                      ),
                    ),
                    Divider()
                  ],
                );
              })),
    );
  }
}
