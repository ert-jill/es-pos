import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/screens/account_form.dart';
import 'package:pos/screens/account_list.dart';
import 'package:pos/screens/area_form.dart';
import 'package:pos/screens/area_list.dart';

import '../services/account_controller.dart';
import '../services/area_controller.dart';

enum AreaModule { list, insert }

class AreaWidget extends StatelessWidget {
  Rx<AreaModule> selectedAreaModule = AreaModule.list.obs;
  final AreaController areaController =
      Get.put<AreaController>(AreaController());
  AreaWidget({super.key});

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
                  areaController.getAreaList();
                },
                icon: Icon(Icons.refresh)),
            SizedBox(
              width: 40,
            )
          ],
        ),
        body: Column(
          children: [getAccountModuleWidget(selectedAreaModule.value)],
        ),
        floatingActionButton: FloatingActionButton.large(
          onPressed: () {
            // Add your onPressed code here!
            Get.dialog(
                Center(
                    child: AreaForm(
                  areaController: areaController,
                )),
                barrierDismissible: false);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  getAccountModuleWidget(AreaModule accountModule) {
    switch (accountModule) {
      case AreaModule.list:
        return AreaList(
          areaController: areaController,
        );
      case AreaModule.insert:
        return Center(
          child: Text('hahahah'),
        );
    }
  }
}
