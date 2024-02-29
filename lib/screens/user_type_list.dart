import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/user_service.dart';

class UserTypeList extends StatelessWidget {
  final UserService userService = Get.find<UserService>();
  UserTypeList({super.key});
  RxBool isLoading = false.obs;

  onInit() async {
    isLoading.value = true;
    await userService.getUserTypes();
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
              itemCount: userService.userTypes.length,
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
                            Text('${userService.userTypes[index].description}'),
                        trailing:
                            Text('${userService.userTypes[index].isActive}'),
                        title:
                            Text('${userService.userTypes[index].name ?? ''}'),
                      ),
                    ),
                    Divider()
                  ],
                );
              })),
    );
  }
}
