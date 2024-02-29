import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../services/account_controller.dart';
import '../services/area_controller.dart';

class AreaList extends StatelessWidget {
  AreaController areaController;
  RxBool isLoading = false.obs;

  AreaList({super.key, required this.areaController});

  onInit() async {
    isLoading.value = true;
    await areaController.getAreaList();
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
              itemCount: areaController.areaList.length,
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
                            Text('${areaController.areaList[index].code}'),
                        trailing:
                            Text('${areaController.areaList[index].isActive}'),
                        title: Text(
                            '${areaController.areaList[index].name ?? ''}'),
                      ),
                    ),
                    Divider()
                  ],
                );
              })),
    );
  }
}
