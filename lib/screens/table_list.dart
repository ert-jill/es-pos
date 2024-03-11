import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../services/area_controller.dart';
import '../services/table_controller.dart';

class TableList extends StatelessWidget {
  TableController tableController;
  RxBool isLoading = false.obs;

  TableList({super.key, required this.tableController});

  onInit() async {
    isLoading.value = true;
    await tableController.getTableList();
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
              itemCount: tableController.tableList.length,
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
                            '${tableController.tableList[index].value.code}'),
                        trailing: Text(
                            '${tableController.tableList[index].value.isActive}'),
                        title: Text(
                            '${tableController.tableList[index].value.name ?? ''}'),
                      ),
                    ),
                    Divider()
                  ],
                );
              })),
    );
  }
}
