import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos/models/classification.dart';
import 'package:pos/models/product.dart';
import 'package:pos/services/order_controller.dart';

import '../models/order.dart';
import '../services/cash_registry_service.dart';
import '../services/classification_controller.dart';
import '../services/product_service.dart';

enum OrderModule { display, view, print }

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
  // Rx<Product?> selectedProduct = Rx(null); // flag if has selected a product
  Rx<OrderItem?> selectedOrderItem =
      Rx(null); // flag if has selected a order item

  Rx<String> selectedMainClassification = ''.obs;
  Rx<String> selectedSubClassification = ''.obs;
  Rx<DateTime> currentDate = DateTime.now().obs;
  Rx<OrderModule> orderItemModule = OrderModule.display.obs;

  TextEditingController quantityTextFieldController = TextEditingController();

  onInit() async {
    mainClassification.value =
        await classificationController.getClassificationList1(null, '0');
    // products.value = await productService.searchProducts(null, null, '1');
    getProductDisplay();
    // subClassification.value =
    //     await classificationController.getClassificationList1(null, '1');
  }

  selectProduct() {}
  selectOrderItem(OrderItem? orderItem) {
    selectedOrderItem.value = orderItem;
    if (selectedOrderItem.value != null) {
      orderItemModule.value = OrderModule.view;
    } else {
      orderItemModule.value = OrderModule.display;
    }
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

  getOrderModuleWidget(OrderModule? orderModule) {
    switch (orderModule) {
      case OrderModule.view:
        return VewOrderItem(
            selectOrderItem: selectOrderItem,
            selectedOrderItem: selectedOrderItem,
            cashRegistryService: cashRegistryService);
      case OrderModule.display:
        return productDisplay();
      default:
        return productDisplay();
    }
  }

  @override
  Widget build(BuildContext context) {
    onInit();
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black,
            child: Row(
              children: [
                Obx(() => getOrderModuleWidget(orderItemModule.value)),
                GestureDetector(
                  onTap: () {
                    selectOrderItem(null);
                  },
                  child: Container(
                    width: 400,
                    height: double.infinity,
                    child: Column(
                      children: [
                        Expanded(
                            child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          padding: EdgeInsets.all(8),
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() => Text(
                                    'Date : ' +
                                        '${DateFormat('MMM dd, yyyy').format(currentDate.value)}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                              Obx(() => Text(
                                    'Order # : ' +
                                        '${cashRegistryService.orderController.selectedOrder.value?.id.toString().padLeft(8, '0')}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )),
                              Obx(() => Text(
                                    'Customer : ${cashRegistryService.orderController.selectedOrder.value?.customer}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                              Divider(),
                              Expanded(
                                child: Obx(() => ListView.builder(
                                      itemCount: cashRegistryService
                                          .orderController.orderItems.length,
                                      // padding: EdgeInsets.all(10),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Obx(() => Container(
                                              color:
                                                  selectedOrderItem.value?.id ==
                                                          cashRegistryService
                                                              .orderController
                                                              .orderItems[index]
                                                              .value
                                                              .id
                                                      ? Colors.green
                                                      : null,
                                              child: ListTile(
                                                selectedColor: Colors.white,
                                                selected: selectedOrderItem
                                                        .value?.id ==
                                                    cashRegistryService
                                                        .orderController
                                                        .orderItems[index]
                                                        .value
                                                        .id,
                                                onTap: () {
                                                  selectOrderItem(
                                                      cashRegistryService
                                                          .orderController
                                                          .orderItems[index]
                                                          .value);
                                                },
                                                title: Text(
                                                    '${cashRegistryService.orderController.orderItems[index].value.id.toString().padLeft(8, '0')} - ${cashRegistryService.orderController.orderItems[index].value.product.name}'),
                                                subtitle: Obx(() => Text(
                                                    '   ${cashRegistryService.orderController.orderItems[index].value.quantity} * ${cashRegistryService.orderController.orderItems[index].value.product.price}')),
                                                trailing: Text(
                                                  '₱ ${(double.parse(cashRegistryService.orderController.orderItems[index].value.product.price) * cashRegistryService.orderController.orderItems[index].value.quantity).toStringAsFixed(2)}',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ),
                                            ));
                                      },
                                    )),
                              ),
                              Divider(),
                              Container(
                                width: double.infinity,
                                height: 120,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Obx(() => Text(
                                          'Sub Total ₱ ${OrderController.getSumOfOrderItems(cashRegistryService.orderController.orderItems).toStringAsFixed(2)}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        )),
                                    Obx(() => Text(
                                          'VAT Amount ₱ ${cashRegistryService.orderController.selectedOrder.value?.totalVat.toStringAsFixed(2)}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        )),
                                    Obx(() => Text(
                                          'Total Discount ₱ ${cashRegistryService.orderController.selectedOrder.value?.totalDiscount.toStringAsFixed(2)}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        )),
                                    Obx(() => Text(
                                          'Total ₱ ${OrderController.getSumOfOrderItems(cashRegistryService.orderController.orderItems).toStringAsFixed(2)}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
                        Container(
                          color: Colors.black,
                          width: double.infinity,
                          height: 100,
                          padding: EdgeInsets.all(10),
                          child: Container(
                            color: Colors.green,
                            height: double.infinity,
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                'Place Order | Bill Out | Close',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Expanded productDisplay() {
    return Expanded(
      child: Column(
        children: [
          Expanded(
              child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                height: double.infinity,
                width: 180,
                color: Colors.black,
                child: Column(
                  children: [
                    Container(
                      height: 70,
                      width: double.infinity,
                    ),
                    Expanded(
                      child: Obx(() => ListView.builder(
                          itemCount: mainClassification.length + 1,
                          itemBuilder: (context, i) {
                            return Obx(() => Container(
                                color: selectedMainClassification.value ==
                                        (i == 0
                                            ? ''
                                            : mainClassification[i - 1]
                                                .id
                                                .toString())
                                    ? Colors.green
                                    : Color.fromARGB(255, 148, 148, 150),
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
                                            : mainClassification[i - 1].name),
                                      ),
                                    ))));
                          })),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.yellow,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 8, 8, 8),
                          color: Colors.black,
                          width: double.infinity,
                          height: 78,
                          child: Obx(() => ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: subClassification.length + 1,
                              itemBuilder: (context, i) {
                                return Obx(() => Container(
                                      width: 180,
                                      color: selectedSubClassification.value ==
                                              (i == 0
                                                  ? ''
                                                  : subClassification[i - 1]
                                                      .id
                                                      .toString())
                                          ? Colors.green
                                          : Color.fromARGB(255, 148, 148, 150),
                                      child: InkWell(
                                        onTap: () {
                                          selectedSubClassification.value =
                                              i == 0
                                                  ? ''
                                                  : subClassification[i - 1]
                                                      .id
                                                      .toString();
                                          selectSubClassification(
                                              selectedSubClassification.value);
                                        },
                                        child: Center(
                                          child: Text(i == 0
                                              ? 'All'
                                              : subClassification[i - 1].name),
                                        ),
                                      ),
                                    ));
                              })),
                        ),
                        Expanded(
                            child: GridView.builder(
                          padding: EdgeInsets.all(8),
                          itemCount: products.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                  childAspectRatio: 2,
                                  crossAxisCount: 4),
                          itemBuilder: (context, i) => Obx(
                            () {
                              // Rx<OrderItem?> orderItem =
                              //     Rx(null);
                              // cashRegistryService
                              //     .orderController
                              //     .isProductInOrderItems(
                              //         products[i])
                              //     .then((result) {
                              //   // Handle the result
                              //   orderItem.value =
                              //       result?.value;
                              // });

                              bool isProductInOrderItems = cashRegistryService
                                  .orderController
                                  .isProductInOrderItems(products[i]);

                              return InkWell(
                                  onTap: () async {
                                    // selectedProduct.value =
                                    //     products[i];

                                    if (!isProductInOrderItems) {
                                      OrderItem? newOrderItem =
                                          await cashRegistryService
                                              .orderController
                                              .addOrderItem(
                                                  cashRegistryService
                                                      .orderController
                                                      .selectedOrder
                                                      .value!
                                                      .id,
                                                  products[i].sku,
                                                  1);

                                      if (newOrderItem != null) {
                                        selectOrderItem(newOrderItem);
                                      }
                                    } else {
                                      Rx<OrderItem> orderItem =
                                          await cashRegistryService
                                              .orderController
                                              .getOrderItem(products[i]);
                                      selectOrderItem(orderItem.value);
                                    }
                                  },
                                  child: Obx(() => Container(
                                        color: isProductInOrderItems
                                            ? Colors.red
                                            : Colors.green,
                                        child: Center(
                                            child: Text(products[i].name)),
                                      )));
                            },
                          ),
                        )),
                      ],
                    )),
              ),
            ],
          )),
          Container(
            color: Colors.black,
            width: double.infinity,
            height: 100,
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    cashRegistryService.navigateTo(CashRegistryModule.menu);
                  },
                  child: Container(
                    color: Colors.red,
                    height: double.infinity,
                    width: 120,
                    child: Center(
                      child: Text(
                        'EXIT',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    cashRegistryService.orderController.printOrderReceipt();
                  },
                  child: Container(
                    color: Colors.green,
                    height: double.infinity,
                    width: 120,
                    child: Center(
                      child: Text(
                        'PRINT',
                        textAlign: TextAlign.center,
                      ),
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

class VewOrderItem extends StatelessWidget {
  const VewOrderItem(
      {super.key,
      required this.selectedOrderItem,
      required this.cashRegistryService,
      required this.selectOrderItem});
  final Function(OrderItem?) selectOrderItem;
  final Rx<OrderItem?> selectedOrderItem;
  final CashRegistryService cashRegistryService;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Color.fromARGB(255, 54, 54, 54),
        child: Column(
          children: [
            Obx(() => Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  width: double.infinity,
                  color: Colors.green,
                  child: Text(
                    '${selectedOrderItem.value?.product.name.capitalize} - (${selectedOrderItem.value?.id.toString().padLeft(8, '0')})',
                    style: TextStyle(color: Colors.black, fontSize: 25),
                  ),
                )),
            Expanded(child: Container()),
            Container(
              height: 100,
              padding: EdgeInsets.all(10),
              color: Colors.black,
              width: double.infinity,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // selectedProduct.value=null;
                    },
                    child: Container(
                      width: 120,
                      color: Colors.red,
                      child: Center(
                        child: Text(
                          'Remove\nItem',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      // selectedProduct.value=null;
                    },
                    child: Container(
                      width: 120,
                      color: Colors.red,
                      child: Center(
                        child: Text(
                          'Void\nItem',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     // selectedProduct.value=null;
                  //   },
                  //   child: Container(
                  //     width: 120,
                  //     color: Colors.green,
                  //     child: Center(
                  //       child: Text(
                  //         'Quantity',
                  //         textAlign: TextAlign.center,
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  Spacer(),

                  GestureDetector(
                    onTap: () async {
                      OrderItem? newOrderItem = await cashRegistryService
                          .orderController
                          .addOrderItem(
                              cashRegistryService
                                  .orderController.selectedOrder.value!.id,
                              selectedOrderItem.value!.product.sku,
                              1);
                      if (newOrderItem != null) {
                        selectOrderItem(newOrderItem);
                      }
                    },
                    child: Container(
                      width: 120,
                      color: Colors.blue,
                      child: Center(
                        child: Text(
                          'Duplicate',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DecimalInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Check if the new value contains only digits and at most one decimal point
    if (RegExp(r'^\d*\.?\d{0,2}$').hasMatch(newValue.text)) {
      return newValue;
    }
    // If the input is not a valid decimal, return the old value
    return oldValue;
  }
}
