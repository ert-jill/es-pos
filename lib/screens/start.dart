import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/screens/area.dart';
import 'package:pos/screens/classification.dart';
import 'package:pos/screens/discount.dart';
import 'package:pos/screens/payment_method.dart';
import 'package:pos/screens/printer.dart';
import 'package:pos/screens/product.dart';
import 'package:pos/screens/table.dart';
import 'package:pos/screens/user.dart';
import 'package:pos/screens/user_type.dart';
import 'package:pos/services/user_service.dart';

import '../services/auth_service.dart';
import '../services/timer.dart';
import 'account.dart';
import 'cash_registry.dart';

class StartScreen extends StatelessWidget {
  final TimeController timeController = Get.put(TimeController());
  final AuthService authService = Get.find<AuthService>();
  final UserService userService = Get.find<UserService>();
  RxString widget = 'Cash Registry'.obs;

  getWidget() {
    switch (widget.value) {
      case 'Cash Registry':
        return CashRegistryWidget();
      case 'Account':
        return AccountWidget();
      case 'Areas':
        return AreaWidget();
      case 'Classification':
        return ClassificationWidget();
      case 'Discounts':
        return DiscountWidget();
      case 'Payment Methods':
        return PaymentMethodWidget();
      case 'Printers':
        return PrinterWidget();
      case 'Products':
        return ProductWidget();
      case 'Users':
        return UserWidget();
      case 'User Type':
        return UserTypeWidget();
      case 'Tables':
        return TableWidget();
      default:
        return CashRegistryWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Obx(() => Scaffold(
            appBar:
                // (widget.value != 'Cash Registry')
                //     ?
                AppBar(
              title: Obx(() => Text(widget.value)),
              actions: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: Obx(() => Text(
                        '${timeController.currentTime}',
                        style: TextStyle(fontSize: 24),
                      )),
                ),
              ],
            ),
            // : null,
            drawer: Drawer(
                child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      DrawerHeader(
                        decoration: BoxDecoration(),
                        child: Text(
                          '${userService.user.value!.firstName} ${userService.user.value!.lastName}',
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text('Cash Registry'),
                        onTap: () {
                          // Update UI based on item selection
                          widget.value = 'Cash Registry';
                          Navigator.of(context).pop();
                        },
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Reports'),
                        dense: true,
                        enabled: false,
                      ),
                      ListTile(
                        title: Text('Genartare'),
                        onTap: () {
                          // Update UI based on item selection
                          // widget.value = 'Cash Registry';
                        },
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Maintenance'),
                        dense: true,
                        enabled: false,
                      ),
                      ListTile(
                        title: Text('Account'),
                        onTap: () {
                          // Update UI based on item selection
                          widget.value = 'Account';
                          Navigator.of(context).pop();
                        },
                      ),
                      ListTile(
                        title: Text('Areas'),
                        onTap: () {
                          // Update UI based on item selection
                          widget.value = 'Areas';
                          Navigator.of(context).pop();
                        },
                      ),
                      ListTile(
                        title: Text('Classification'),
                        onTap: () {
                          // Update UI based on item selection
                          widget.value = 'Classification';
                          Navigator.of(context).pop();
                        },
                      ),
                      ListTile(
                        title: Text('Discounts'),
                        onTap: () {
                          // Update UI based on item selection
                          widget.value = 'Discounts';
                          Navigator.of(context).pop();
                        },
                      ),
                      ListTile(
                        title: Text('Payment Methods'),
                        onTap: () {
                          // Update UI based on item selection
                          widget.value = 'Payment Methods';
                          Navigator.of(context).pop();
                        },
                      ),
                      ListTile(
                        title: Text('Printers'),
                        onTap: () {
                          // Update UI based on item selection
                          widget.value = 'Printers';
                          Navigator.of(context).pop();
                        },
                      ),
                      ListTile(
                        title: Text('Products'),
                        onTap: () {
                          // Update UI based on item selection
                          widget.value = 'Products';
                          Navigator.of(context).pop();
                        },
                      ),
                      ListTile(
                        title: Text('Users'),
                        onTap: () {
                          // Update UI based on item selection
                          widget.value = 'Users';
                          Navigator.of(context).pop();
                        },
                      ),
                      ListTile(
                        title: Text('User Type'),
                        onTap: () {
                          // Update UI based on item selection
                          widget.value = 'User Type';
                          Navigator.of(context).pop();
                        },
                      ),
                      ListTile(
                        title: Text('Tables'),
                        onTap: () {
                          // Update UI based on item selection
                          widget.value = 'Tables';
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text('Logout'),
                  onTap: () async {
                    // Update UI based on item selection
                    await authService.logout();
                  },
                ),
              ],
            )),
            body: Obx(() => getWidget()))));
  }
}
