import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/screens/area_form.dart';
import 'package:pos/screens/area_list.dart';
import 'package:pos/screens/table_list.dart';
import '../services/table_controller.dart';

enum TableModule { list, insert }

class TableWidget extends StatelessWidget {
  Rx<TableModule> selectedTableModule = TableModule.list.obs;
  final TableController tableController =
      Get.put<TableController>(TableController());
  TableWidget({super.key});

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
                  tableController.getTableList();
                },
                icon: Icon(Icons.refresh)),
            SizedBox(
              width: 40,
            )
          ],
        ),
        body: Column(
          children: [getAccountModuleWidget(selectedTableModule.value)],
        ),
        floatingActionButton: FloatingActionButton.large(
          onPressed: () {
            // Add your onPressed code here!
            Get.dialog(
                Center(
                    //     child: AreaForm(
                    //   tableController: tableController,
                    // )
                    ),
                barrierDismissible: false);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  getAccountModuleWidget(TableModule accountModule) {
    switch (accountModule) {
      case TableModule.list:
        return TableList(
          tableController: tableController,
        );
      case TableModule.insert:
        return Center(
          child: Text('hahahah'),
        );
    }
  }
}
