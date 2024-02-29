import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/screens/account_form.dart';
import 'package:pos/screens/account_list.dart';
import 'package:pos/screens/discount_form.dart';
import 'package:pos/screens/discount_list.dart';
import '../services/discount_controller.dart';

enum DiscountModule { list, insert }

class DiscountWidget extends StatelessWidget {
  Rx<DiscountModule> selectedDiscountModule = DiscountModule.list.obs;
  final DiscountController discountController =
      Get.put<DiscountController>(DiscountController());
  DiscountWidget({super.key});

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
                  discountController.getDiscountList();
                },
                icon: Icon(Icons.refresh)),
            SizedBox(
              width: 40,
            )
          ],
        ),
        body: Column(
          children: [getAccountModuleWidget(selectedDiscountModule.value)],
        ),
        floatingActionButton: FloatingActionButton.large(
          onPressed: () {
            // Add your onPressed code here!
            Get.dialog(
                Center(
                    child: DiscountForm(
                  discountController: discountController,
                )),
                barrierDismissible: false);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  getAccountModuleWidget(DiscountModule accountModule) {
    switch (accountModule) {
      case DiscountModule.list:
        return DiscountList(
          discountController: discountController,
        );
      case DiscountModule.insert:
        return Center(
          child: Text('hahahah'),
        );
    }
  }
}
