import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/screens/account_form.dart';
import 'package:pos/screens/account_list.dart';
import 'package:pos/screens/classification_form.dart';
import 'package:pos/screens/classification_list.dart';

import '../services/account_controller.dart';
import '../services/classification_controller.dart';

enum ClssificationModule { list, insert }

class ClassificationWidget extends StatelessWidget {
  Rx<ClssificationModule> selectedAccountModule = ClssificationModule.list.obs;
  final ClassificationController classificationController =
      Get.put<ClassificationController>(ClassificationController());
  ClassificationWidget({super.key});

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
                  classificationController.getClassificationList(null, null);
                },
                icon: Icon(Icons.refresh)),
            SizedBox(
              width: 40,
            )
          ],
        ),
        body: Column(
          children: [
            getClassificationModuleWidget(selectedAccountModule.value)
          ],
        ),
        floatingActionButton: FloatingActionButton.large(
          onPressed: () {
            // Add your onPressed code here!
            Get.dialog(
                Center(
                    child: ClassificationForm(
                  classificationController: classificationController,
                )),
                barrierDismissible: false);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  getClassificationModuleWidget(ClssificationModule accountModule) {
    switch (accountModule) {
      case ClssificationModule.list:
        return ClassificationList(
          classificationController: classificationController,
        );
      case ClssificationModule.insert:
        return Center(
          child: Text('hahahah'),
        );
    }
  }
}
