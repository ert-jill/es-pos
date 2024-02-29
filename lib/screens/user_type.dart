import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/screens/user_type_form.dart';
import 'package:pos/screens/user_type_list.dart';

enum UserTypeModule { list, insert }

class UserTypeWidget extends StatelessWidget {
  Rx<UserTypeModule> selectedUserTypeModule = UserTypeModule.list.obs;
  UserTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.refresh)),
            SizedBox(
              width: 40,
            )
          ],
        ),
        body: Column(
          children: [getAccountModuleWidget(selectedUserTypeModule.value)],
        ),
        floatingActionButton: FloatingActionButton.large(
          onPressed: () {
            // Add your onPressed code here!
            Get.dialog(Center(child: UserTypeForm()),
                barrierDismissible: false);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  getAccountModuleWidget(UserTypeModule accountModule) {
    switch (accountModule) {
      case UserTypeModule.list:
        return UserTypeList();
      case UserTypeModule.insert:
        return Center(
          child: Text('hahahah'),
        );
    }
  }
}
