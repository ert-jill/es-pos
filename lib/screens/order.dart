import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pos/models/classification.dart';
import 'package:pos/models/product.dart';

import '../models/order.dart';
import '../services/cash_registry_service.dart';
import '../services/classification_controller.dart';
import '../services/product_service.dart';

class OrderWidget extends StatelessWidget {
  CashRegistryService cashRegistryService = Get.find<CashRegistryService>();
  final ClassificationController classificationController =
      Get.put<ClassificationController>(ClassificationController());
  final ProductService productService = Get.find<ProductService>();
  Rx<Order?> order = Rx(null);
  OrderWidget({super.key, required this.order});
  RxList<Classification> mainClassification = RxList.empty();
  RxList<Classification> subClassification = RxList.empty();
  RxList<Product> products = RxList.empty();

  Rx<String> selectedMainClassification = ''.obs;
  Rx<String> selectedSubClassification = ''.obs;

  onInit() async {
    mainClassification.value =
        await classificationController.getClassificationList1(null, '0');
    // products.value = await productService.searchProducts(null, null, '1');
    getProductDisplay();
    // subClassification.value =
    //     await classificationController.getClassificationList1(null, '1');
  }

  selectMainClassification(String classification) async {
    selectedMainClassification.value = classification;
    selectedSubClassification.value = '';
    if (classification == '') {
      subClassification.value = [];
      // products.value = await productService.searchProducts(null, null, '1');
      getProductDisplay();
    } else {
      getProductDisplay();
      subClassification.value =
          await classificationController.getClassificationList1(
              classification != '' ? classification : null, '1');
    }
    getProductDisplay();
  }

  selectSubClassification(String classification) async {
    getProductDisplay();
  }

  getProductDisplay() async {
    products.value = await productService.searchProducts(
        null,
        selectedSubClassification.value != ''
            ? selectedSubClassification.value
            : selectedMainClassification.value != ''
                ? selectedMainClassification.value
                : null,
        '1');
  }

  @override
  Widget build(BuildContext context) {
    onInit();
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 250,
                  // color: Colors.blue,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Category'),
                      ),
                      Expanded(
                          child: Obx(() => ListView.builder(
                              padding: EdgeInsetsDirectional.all(8),
                              itemCount: mainClassification.length + 1,
                              itemBuilder: (context, i) {
                                return Obx(() => Card(
                                    color: selectedMainClassification.value ==
                                            (i == 0
                                                ? ''
                                                : mainClassification[i - 1]
                                                    .id
                                                    .toString())
                                        ? Colors.green
                                        : null,
                                    child: InkWell(
                                        onTap: () {
                                          selectMainClassification(i == 0
                                              ? ''
                                              : mainClassification[i - 1]
                                                  .id
                                                  .toString());
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Center(
                                            child: Text(i == 0
                                                ? 'All'
                                                : mainClassification[i - 1]
                                                    .name),
                                          ),
                                        ))));
                              })))
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text('Sub Category'),
                            ),
                            Container(
                              width: double.infinity,
                              height: 80,
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: ScrollConfiguration(
                                behavior: ScrollConfiguration.of(context)
                                    .copyWith(dragDevices: {
                                  PointerDeviceKind.touch,
                                  PointerDeviceKind.mouse,
                                }),
                                child: Obx(() => ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: subClassification.length + 1,
                                    itemBuilder: (context, i) {
                                      return Container(
                                        width: 200.0,
                                        child: Obx(() => Card(
                                              color: selectedSubClassification
                                                          .value ==
                                                      (i == 0
                                                          ? ''
                                                          : subClassification[
                                                                  i - 1]
                                                              .id
                                                              .toString())
                                                  ? Colors.green
                                                  : null,
                                              child: InkWell(
                                                onTap: () {
                                                  selectedSubClassification
                                                      .value = i ==
                                                          0
                                                      ? ''
                                                      : subClassification[i - 1]
                                                          .id
                                                          .toString();
                                                  selectSubClassification(
                                                      selectedSubClassification
                                                          .value);
                                                },
                                                child: Center(
                                                  child: Text(i == 0
                                                      ? 'All'
                                                      : subClassification[i - 1]
                                                          .name),
                                                ),
                                              ),
                                            )),
                                      );
                                    })),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: Obx(() => GridView.builder(
                              itemCount: products.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4),
                              itemBuilder: (context, i) => Card(
                                    child: Obx(() {
                                      int index = cashRegistryService
                                          .orderController
                                          .indexOfProductInOrder(
                                              products[i].sku);
                                      return InkWell(
                                        onTap: () {
                                          cashRegistryService.orderController
                                              .addOrderItem(order.value!.id,
                                                  products[i], 1);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              Center(
                                                  child:
                                                      Text(products[i].name)),
                                              Spacer(),
                                              if (index > -1)
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    IconButton(
                                                        onPressed: () async {
                                                          await cashRegistryService
                                                              .orderController
                                                              .removeItemQuantity(
                                                            cashRegistryService
                                                                .orderController
                                                                .selectedOrder
                                                                .value!
                                                                .id,
                                                            products[i].sku,
                                                          );
                                                          print(
                                                              products[i].sku);
                                                          print(
                                                              index.toString());
                                                          print(cashRegistryService
                                                              .orderController
                                                              .orderItems[index]
                                                              .value
                                                              .id);
                                                        },
                                                        icon:
                                                            Icon(Icons.remove)),
                                                    IconButton(
                                                        onPressed: () {
                                                          cashRegistryService
                                                              .orderController
                                                              .addItemQuantity(
                                                            cashRegistryService
                                                                .orderController
                                                                .selectedOrder
                                                                .value!
                                                                .id,
                                                            products[i].sku,
                                                          );
                                                        },
                                                        icon: Icon(Icons.add)),
                                                  ],
                                                )
                                              // else
                                              //   ElevatedButton(
                                              //       onPressed: () {

                                              //       },
                                              //       child: Text('Add'))
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                  )))),
                    ],
                  ),
                ),
                Container(
                  // color: Colors.blue,
                  width: 400,
                  child: Column(
                    children: [
                      Obx(() => (order.value?.tables != null)
                          ? Container(
                              height: 50,
                              width: double.infinity,
                              child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: ListTile(
                                    title: Text(
                                        'Table(s) : ${order.value!.tables}'),
                                  )),
                            )
                          : Container(
                              height: 50,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: ListTile(
                                  title: Text(
                                      'Order No : ${order.value?.id.toString()}'),
                                ),
                              ),
                            )),
                      Expanded(
                          child: Obx(() => ListView.builder(
                                itemCount: cashRegistryService
                                    .orderController.orderItems.length,
                                padding: EdgeInsets.all(10),
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    onTap: () {},
                                    leading:
                                        Icon(Icons.check_box_outline_blank),
                                    title: Text(cashRegistryService
                                        .orderController
                                        .orderItems[index]
                                        .value
                                        .product
                                        .name),
                                    subtitle: Obx(() => Text(
                                        'Quantity: ${cashRegistryService.orderController.orderItems[index].value.quantity}')),
                                    trailing: Text((double.parse(
                                                cashRegistryService
                                                    .orderController
                                                    .orderItems[index]
                                                    .value
                                                    .product
                                                    .price) *
                                            cashRegistryService
                                                .orderController
                                                .orderItems[index]
                                                .value
                                                .quantity)
                                        .toStringAsFixed(2)),
                                  );
                                },
                              ))),
                      Container(
                          width: double.infinity,
                          // color: Colors.amber,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Sub Total'),
                                    Text('${order.value?.total}')
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Total VAT'),
                                    Text('${order.value?.total}')
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Payable Amount'),
                                    Text('${order.value?.total}')
                                  ],
                                ),
                                Container(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    height: 100,
                                    width: double.infinity,
                                    child: Card(
                                        child: InkWell(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child:
                                            Center(child: Text('Place Order')),
                                      ),
                                    )))
                              ],
                            ),
                          )
                          // Expanded(
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(10),
                          //     child: Column(
                          //       children: [
                          //         Expanded(
                          //             child: Column(
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.start,
                          //           children: [
                          //             Padding(
                          //               padding: const EdgeInsets.all(8.0),
                          //               child: Text('Payment(s)'),
                          //             ),
                          //             Expanded(
                          //               child: ListView(
                          //                 padding: EdgeInsets.fromLTRB(
                          //                     10, 0, 10, 10),
                          //                 children: [
                          //                   Row(
                          //                     children: [Text('data')],
                          //                   )
                          //                 ],
                          //               ),
                          //             ),
                          //           ],
                          //         )),
                          //         Spacer(),
                          //         Container(
                          //           color: Colors.red,
                          //           height: 100,
                          //           width: double.infinity,
                          //           child: Column(
                          //             crossAxisAlignment:
                          //                 CrossAxisAlignment.start,
                          //             children: [
                          //               Text('Total Amount'),
                          //               Text('Payment Amount')
                          //             ],
                          //           ),
                          //         ),
                          //         // Container(
                          //         //   width: double.infinity,
                          //         //   child: FilledButton(
                          //         //     onPressed: () {},
                          //         //     child: Padding(
                          //         //       padding: const EdgeInsets.all(15),
                          //         //       child: const Text('Place Order'),
                          //         //     ),
                          //         //   ),
                          //         // ),
                          //         Container(
                          //           padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          //           height: 100,
                          //           width: double.infinity,
                          //           child: Card(
                          //               child: InkWell(
                          //             onTap: () {},
                          //             child: Padding(
                          //               padding: const EdgeInsets.all(8.0),
                          //               child:
                          //                   Center(child: Text('Place Order')),
                          //             ),
                          //           )),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // )
                          )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            height: 100,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 200.0,
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        cashRegistryService.navigateTo(CashRegistryModule.menu);
                      },
                      child: Center(
                        child: Text('New Order'),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 200.0,
                  child: Card(
                    child: Center(
                      child: Text('Void'),
                    ),
                  ),
                ),
                Container(
                  width: 200.0,
                  child: Card(
                    child: Center(
                      child: Text('Item 1'),
                    ),
                  ),
                ),
                Container(
                  width: 200.0,
                  child: Card(
                    child: Center(
                      child: Text('Item 1'),
                    ),
                  ),
                ),
                Container(
                  width: 200.0,
                  child: Card(
                    child: Center(
                      child: Text('Discount'),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
