import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/services/order_controller.dart';
import '../models/order.dart';
import '../screens/dine.dart';
import '../screens/order.dart';

enum CashRegistryModule { menu, order, dine }

class CashRegistryService extends GetxService {
  Rx<CashRegistryModule> selectedModule = CashRegistryModule.menu.obs;
  OrderController orderController = Get.put(OrderController());

  navigateTo(CashRegistryModule module) {
    selectedModule.value = module;
  }

  getModuleWidget(CashRegistryModule selected) {
    switch (selected) {
      case CashRegistryModule.menu:
        return menu();
      case CashRegistryModule.dine:
        return DineWidget();
      case CashRegistryModule.order:
        return OrderWidget(order: orderController.selectedOrder);
      default:
        return menu();
    }
  }

  Center menu() {
    return Center(
      child: Container(
        width: 700,
        child: Center(
          child: GridView.count(
            crossAxisCount: 2, // Number of columns
            children: <Widget>[
              Card(
                margin: EdgeInsets.all(10),
                child: InkWell(
                  onTap: () {
                    // Handle button tap
                    selectedModule.value = CashRegistryModule.dine;
                    print('Button tapped');
                  },
                  child: Center(
                    child: Text(
                      'Dine-In',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.all(10),
                child: InkWell(
                  onTap: () {
                    // Handle button tap
                    selectedModule.value = CashRegistryModule.order;
                    print('Button tapped');
                  },
                  child: Center(
                    child: Text(
                      'Take-Out',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
