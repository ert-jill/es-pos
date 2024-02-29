import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/screens/account_form.dart';
import 'package:pos/screens/account_list.dart';

import '../services/account_controller.dart';

enum AccountModule { list, insert }

class AccountWidget extends StatelessWidget {
  Rx<AccountModule> selectedAccountModule = AccountModule.list.obs;
  final AccountController accountController =
      Get.put<AccountController>(AccountController());
  AccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  accountController.getAccountList();
                },
                icon: Icon(Icons.refresh)),
            SizedBox(
              width: 40,
            )
          ],
        ),
        body: Column(
          children: [getAccountModuleWidget(selectedAccountModule.value)],
        ),
        floatingActionButton: FloatingActionButton.large(
          onPressed: () {
            // Add your onPressed code here!
            Get.dialog(Center(child: AccountForm()), barrierDismissible: false);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  getAccountModuleWidget(AccountModule accountModule) {
    switch (accountModule) {
      case AccountModule.list:
        return AccountList(
          accountController: accountController,
        );
      case AccountModule.insert:
        return Center(
          child: Text('hahahah'),
        );
    }
  }
}
