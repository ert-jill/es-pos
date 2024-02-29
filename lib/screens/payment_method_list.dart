import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../services/account_controller.dart';
import '../services/payment_method_controller.dart';

class PaymentMethodList extends StatelessWidget {
  PaymentMethodController paymentMethodController;
  RxBool isLoading = false.obs;

  PaymentMethodList({super.key, required this.paymentMethodController});

  onInit() async {
    isLoading.value = true;
    await paymentMethodController.getPaymentMethodList();
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
              itemCount: paymentMethodController.paymentMethodList.length,
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
                            '${paymentMethodController.paymentMethodList[index].description}'),
                        trailing: Text(
                            '${paymentMethodController.paymentMethodList[index].type}'),
                        title: Text(
                            '${paymentMethodController.paymentMethodList[index].name ?? ''} ${paymentMethodController.paymentMethodList[index].accountNumber ?? ''}'),
                      ),
                    ),
                    Divider()
                  ],
                );
              })),
    );
  }
}
