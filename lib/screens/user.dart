import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/screens/user_form.dart';
import 'package:pos/screens/user_list.dart';

enum UserModule { list, insert }

class UserWidget extends StatelessWidget {
  Rx<UserModule> selectedUserModule = UserModule.list.obs;
  UserWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Obx(() => SegmentedButton<UserModule>(
              //       showSelectedIcon: false,
              //       segments: const <ButtonSegment<UserModule>>[
              //         ButtonSegment<UserModule>(
              //             value: UserModule.list,
              //             label: Padding(
              //               padding: EdgeInsets.all(20),
              //               child: Text('List'),
              //             ),
              //             icon: Icon(Icons.list_outlined)),
              //         ButtonSegment<UserModule>(
              //             value: UserModule.insert,
              //             label: Padding(
              //               padding: EdgeInsets.all(20),
              //               child: Text('Add'),
              //             ),
              //             icon: Icon(Icons.person_add_outlined)),
              //       ],
              //       selected: <UserModule>{selectedUserModule.value},
              //       onSelectionChanged: (newSelection) {
              //         selectedUserModule.value = newSelection.first;
              //       },
              //     )),
              Obx(() => getUserModuleWidget(selectedUserModule.value))
            ],
          ),
          floatingActionButton: FloatingActionButton.large(
            onPressed: () {
              // Add your onPressed code here!
              Get.dialog(Center(child: UserForm()), barrierDismissible: false);
            },
            child: const Icon(Icons.add),
          ),
        ));
  }

  getUserModuleWidget(UserModule userModule) {
    switch (userModule) {
      case UserModule.list:
        return UserList();
      case UserModule.insert:
        return UserForm();
    }
  }
}
