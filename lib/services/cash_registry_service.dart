import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/services/order_controller.dart';
import 'package:pos/services/timer.dart';
import '../screens/dine.dart';
import '../screens/menu.dart';
import '../screens/order.dart';

enum CashRegistryModule { menu, clockIn, order, dine }

class CashRegistryService extends GetxService {
  final TimeController timeController = Get.put(TimeController());
  Rx<CashRegistryModule> selectedModule = CashRegistryModule.clockIn.obs;
  OrderController orderController = Get.put(OrderController());

  navigateTo(CashRegistryModule module) {
    selectedModule.value = module;
    print('$module');
  }

  getModuleWidget(CashRegistryModule selected) {
    switch (selected) {
      case CashRegistryModule.menu:
        return Menu();
      case CashRegistryModule.clockIn:
        return getClockIn();
      case CashRegistryModule.dine:
        return DineWidget();
      case CashRegistryModule.order:
        return OrderWidget(order: orderController.selectedOrder);
      default:
        return getClockIn();
    }
  }

  Widget menu() {
    return Menu();
    // Center(
    //   child: Container(
    //     width: 700,
    //     child: Center(
    //       child: GridView.count(
    //         crossAxisCount: 2, // Number of columns
    //         children: <Widget>[
    //           Card(
    //             margin: EdgeInsets.all(10),
    //             child: InkWell(
    //               onTap: () {
    //                 // Handle button tap
    //                 selectedModule.value = CashRegistryModule.dine;
    //                 print('Button tapped');
    //               },
    //               child: Center(
    //                 child: Text(
    //                   'Dine-In',
    //                   style: TextStyle(fontSize: 20),
    //                 ),
    //               ),
    //             ),
    //           ),
    //           Card(
    //             margin: EdgeInsets.all(10),
    //             child: InkWell(
    //               onTap: () {
    //                 // Handle button tap
    //                 selectedModule.value = CashRegistryModule.order;
    //                 print('Button tapped');
    //               },
    //               child: Center(
    //                 child: Text(
    //                   'Take-Out',
    //                   style: TextStyle(fontSize: 20),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // )
  }

  Widget getClockIn() {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Container(
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'User Type',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Time In',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Time Out',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Total Time',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              ],
              rows: const <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text(
                      'Cashier',
                      textAlign: TextAlign.center,
                    )),
                    DataCell(Text(
                      '10/12/20\n4:10 PM',
                      textAlign: TextAlign.center,
                    )),
                    DataCell(Text(
                      '10/12/20\n4:10 PM',
                      textAlign: TextAlign.center,
                    )),
                    DataCell(Text(
                      '8:00',
                      textAlign: TextAlign.center,
                    )),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text(
                      'Cashier',
                      textAlign: TextAlign.center,
                    )),
                    DataCell(Text(
                      '10/12/20\n4:10 PM',
                      textAlign: TextAlign.center,
                    )),
                    DataCell(Text(
                      '10/12/20\n4:10 PM',
                      textAlign: TextAlign.center,
                    )),
                    DataCell(Text(
                      '8:00',
                      textAlign: TextAlign.center,
                    )),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text(
                      'Cashier',
                      textAlign: TextAlign.center,
                    )),
                    DataCell(Text(
                      '10/12/20\n4:10 PM',
                      textAlign: TextAlign.center,
                    )),
                    DataCell(Text(
                      '10/12/20\n4:10 PM',
                      textAlign: TextAlign.center,
                    )),
                    DataCell(Text(
                      '8:00',
                      textAlign: TextAlign.center,
                    )),
                  ],
                ),
              ],
            ),
          )),
          Container(
            height: double.infinity,
            width: 450,
            color: Colors.black,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 250,
                  height: 150,
                  color: Colors.white,
                ),
                Obx(() => Text(
                      '${timeController.currentTime}',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    )),
                Container(
                  width: 250,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onPressed: () {
                        selectedModule.value = CashRegistryModule.menu;
                      },
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('Clock In'),
                      )),
                ),
                Container(
                  width: 250,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onPressed: () {},
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('Cancel'),
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
