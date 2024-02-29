import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/screens/account_form.dart';
import 'package:pos/screens/account_list.dart';
import 'package:pos/screens/paymentt_method_form.dart';
import '../services/payment_method_controller.dart';
import 'payment_method_list.dart';

enum PaymentMethodModule { list, insert }

class PaymentMethodWidget extends StatelessWidget {
  Rx<PaymentMethodModule> selectedPaymentMethodModule =
      PaymentMethodModule.list.obs;
  final PaymentMethodController paymentMethodController =
      Get.put<PaymentMethodController>(PaymentMethodController());
  PaymentMethodWidget({super.key});

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
                  paymentMethodController.getPaymentMethodList();
                },
                icon: Icon(Icons.refresh)),
            SizedBox(
              width: 40,
            )
          ],
        ),
        body: Column(
          children: [getAccountModuleWidget(selectedPaymentMethodModule.value)],
        ),
        floatingActionButton: FloatingActionButton.large(
          onPressed: () {
            // Add your onPressed code here!
            Get.dialog(Center(child: PaymentMethodForm()),
                barrierDismissible: false);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  getAccountModuleWidget(PaymentMethodModule accountModule) {
    switch (accountModule) {
      case PaymentMethodModule.list:
        return PaymentMethodList(
          paymentMethodController: paymentMethodController,
        );
      case PaymentMethodModule.insert:
        return Center(
          child: Text('hahahah'),
        );
    }
  }
}
