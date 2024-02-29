import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/user_service.dart';

class UserList extends StatelessWidget {
  final UserService userService = Get.find<UserService>();
  UserList({super.key});
  RxBool isLoading = false.obs;

  onInit() async {
    isLoading.value = true;
    await userService.getUserList();
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
              itemCount: userService.userList.length,
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
                        subtitle:
                            Text('${userService.userList[index].username}'),
                        trailing: Text('${userService.userList[index].email}'),
                        title: Text(
                            '${userService.userList[index].firstName ?? 'Emerson'} ${userService.userList[index].lastName ?? 'Gwapo'}'),
                      ),
                    ),
                    Divider()
                  ],
                );
              })),
    );
  }
}
