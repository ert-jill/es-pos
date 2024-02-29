import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../services/account_controller.dart';
import '../services/classification_controller.dart';

class ClassificationList extends StatelessWidget {
  ClassificationController classificationController;
  RxBool isLoading = false.obs;

  ClassificationList({super.key, required this.classificationController});

  onInit() async {
    isLoading.value = true;
    await classificationController.getAccountList();
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
              itemCount: classificationController.classificationList.length,
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
                            '${classificationController.classificationList[index].description}'),
                        trailing: Text(
                            '${classificationController.classificationList[index].parent ?? ''}'),
                        title: Text(
                            '${classificationController.classificationList[index].name} ${classificationController.classificationList[index].depth}'),
                      ),
                    ),
                    Divider()
                  ],
                );
              })),
    );
  }
}
