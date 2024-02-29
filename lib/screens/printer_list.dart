import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../services/account_controller.dart';
import '../services/printer_controller.dart';

class PrinterList extends StatelessWidget {
  PrinterController printerController;
  RxBool isLoading = false.obs;

  PrinterList({super.key, required this.printerController});

  onInit() async {
    isLoading.value = true;
    await printerController.getPrinterList();
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
              itemCount: printerController.printerList.length,
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
                            '${printerController.printerList[index].connection}'),
                        trailing: Text(
                            '${printerController.printerList[index].isActive}'),
                        title: Text(
                            '${printerController.printerList[index].name ?? ''} ${printerController.printerList[index].description ?? ''}'),
                      ),
                    ),
                    Divider()
                  ],
                );
              })),
    );
  }
}
