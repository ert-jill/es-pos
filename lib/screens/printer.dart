import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/screens/account_form.dart';
import 'package:pos/screens/account_list.dart';
import 'package:pos/screens/printer_form.dart';
import 'package:pos/screens/printer_list.dart';
import 'package:pos/services/printer_controller.dart';

enum PrinterModule { list, insert }

class PrinterWidget extends StatelessWidget {
  Rx<PrinterModule> selectedPrinterModule = PrinterModule.list.obs;
  final PrinterController printerController =
      Get.put<PrinterController>(PrinterController());
  PrinterWidget({super.key});

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
                  printerController.getPrinterList();
                },
                icon: Icon(Icons.refresh)),
            SizedBox(
              width: 40,
            )
          ],
        ),
        body: Column(
          children: [getAccountModuleWidget(selectedPrinterModule.value)],
        ),
        floatingActionButton: FloatingActionButton.large(
          onPressed: () {
            // Add your onPressed code here!
            Get.dialog(
                Center(
                    child: PrinterForm(
                  printerController: printerController,
                )),
                barrierDismissible: false);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  getAccountModuleWidget(PrinterModule accountModule) {
    switch (accountModule) {
      case PrinterModule.list:
        return PrinterList(
          printerController: printerController,
        );
      case PrinterModule.insert:
        return Center(
          child: Text('hahahah'),
        );
    }
  }
}
