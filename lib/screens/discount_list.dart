import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/account_controller.dart';
import '../services/discount_controller.dart';

class DiscountList extends StatelessWidget {
  DiscountController discountController;
  RxBool isLoading = false.obs;

  DiscountList({super.key, required this.discountController});

  onInit() async {
    isLoading.value = true;
    await discountController.getDiscountList();
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
              itemCount: discountController.discountList.length,
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
                            '${discountController.discountList[index].description}'),
                        trailing: Text(
                            '${discountController.discountList[index].isActive}'),
                        title: Text(
                            '${discountController.discountList[index].name ?? ''} ${discountController.discountList[index].amount ?? ''} ${discountController.discountList[index].amountType.toUpperCase() ?? ''}'),
                      ),
                    ),
                    Divider()
                  ],
                );
              })),
    );
  }
}
