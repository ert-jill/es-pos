import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/constant.dart';
import 'package:pos/screens/area.dart';
import 'package:pos/screens/classification.dart';
import 'package:pos/screens/discount.dart';
import 'package:pos/screens/payment_method.dart';
import 'package:pos/screens/printer.dart';
import 'package:pos/screens/product.dart';
import 'package:pos/screens/table.dart';
import 'package:pos/screens/user.dart';
import 'package:pos/screens/user_type.dart';

import '../services/auth_service.dart';
import '../services/timer.dart';
import 'account.dart';

class StartScreen extends StatelessWidget {
  final TimeController timeController = Get.put(TimeController());
  final AuthService authService = Get.find<AuthService>();
  RxString widget = 'Menu'.obs;

  getWidget() {
    switch (widget.value) {
      case 'Menu':
        return Menu();
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
        return Menu();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
        drawer: Drawer(
            child: Column(
          children: [
            Expanded(
              child: ListView(
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(),
                    child: Text(
                      'Emerson Benatiro',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text('Menu'),
                    onTap: () {
                      // Update UI based on item selection
                      widget.value = 'Menu';
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
                    },
                  ),
                  ListTile(
                    title: Text('Areas'),
                    onTap: () {
                      // Update UI based on item selection
                      widget.value = 'Areas';
                    },
                  ),
                  ListTile(
                    title: Text('Classification'),
                    onTap: () {
                      // Update UI based on item selection
                      widget.value = 'Classification';
                    },
                  ),
                  ListTile(
                    title: Text('Discounts'),
                    onTap: () {
                      // Update UI based on item selection
                      widget.value = 'Discounts';
                    },
                  ),
                  ListTile(
                    title: Text('Payment Methods'),
                    onTap: () {
                      // Update UI based on item selection
                      widget.value = 'Payment Methods';
                    },
                  ),
                  ListTile(
                    title: Text('Printers'),
                    onTap: () {
                      // Update UI based on item selection
                      widget.value = 'Printers';
                    },
                  ),
                  ListTile(
                    title: Text('Products'),
                    onTap: () {
                      // Update UI based on item selection
                      widget.value = 'Products';
                    },
                  ),
                  ListTile(
                    title: Text('Users'),
                    onTap: () {
                      // Update UI based on item selection
                      widget.value = 'Users';
                    },
                  ),
                  ListTile(
                    title: Text('User Type'),
                    onTap: () {
                      // Update UI based on item selection
                      widget.value = 'User Type';
                    },
                  ),
                  ListTile(
                    title: Text('Tables'),
                    onTap: () {
                      // Update UI based on item selection
                      widget.value = 'Tables';
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
        body: Obx(() => getWidget()));
  }
}

class Menu extends StatelessWidget {
  const Menu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 700,
        child: GridView.count(
          crossAxisCount: 2, // Number of columns
          children: <Widget>[
            Card(
              margin: EdgeInsets.all(10),
              child: InkWell(
                onTap: () {
                  // Handle button tap
                  print('Button tapped');
                },
                child: Center(
                  child: Text(
                    'title',
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
                  print('Button tapped');
                },
                child: Center(
                  child: Text(
                    'title',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
