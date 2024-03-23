import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
  Rx<Product?> selectedProduct = Rx(null); // flag if has selected a product

  Rx<String> selectedMainClassification = ''.obs;
  Rx<String> selectedSubClassification = ''.obs;
  Rx<DateTime> currentDate = DateTime.now().obs;

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
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black,
            child: Row(
              children: [
                Obx(() => selectedProduct.value == null
                    ? Expanded(
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
                                            itemCount:
                                                mainClassification.length + 1,
                                            itemBuilder: (context, i) {
                                              return Obx(() => Container(
                                                  color: selectedMainClassification
                                                              .value ==
                                                          (i == 0
                                                              ? ''
                                                              : mainClassification[
                                                                      i - 1]
                                                                  .id
                                                                  .toString())
                                                      ? Colors.green
                                                      : Color.fromARGB(
                                                          255, 148, 148, 150),
                                                  child: InkWell(
                                                      onTap: () {
                                                        selectMainClassification(i ==
                                                                0
                                                            ? ''
                                                            : mainClassification[
                                                                    i - 1]
                                                                .id
                                                                .toString());
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(20.0),
                                                        child: Center(
                                                          child: Text(i == 0
                                                              ? 'All'
                                                              : mainClassification[
                                                                      i - 1]
                                                                  .name),
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
                                            padding:
                                                EdgeInsets.fromLTRB(0, 8, 8, 8),
                                            color: Colors.black,
                                            width: double.infinity,
                                            height: 78,
                                            child: Obx(() => ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    subClassification.length +
                                                        1,
                                                itemBuilder: (context, i) {
                                                  return Obx(() => Container(
                                                        width: 180,
                                                        color: selectedSubClassification
                                                                    .value ==
                                                                (i == 0
                                                                    ? ''
                                                                    : subClassification[
                                                                            i -
                                                                                1]
                                                                        .id
                                                                        .toString())
                                                            ? Colors.green
                                                            : Color.fromARGB(
                                                                255,
                                                                148,
                                                                148,
                                                                150),
                                                        child: InkWell(
                                                          onTap: () {
                                                            selectedSubClassification
                                                                .value = i ==
                                                                    0
                                                                ? ''
                                                                : subClassification[
                                                                        i - 1]
                                                                    .id
                                                                    .toString();
                                                            selectSubClassification(
                                                                selectedSubClassification
                                                                    .value);
                                                          },
                                                          child: Center(
                                                            child: Text(i == 0
                                                                ? 'All'
                                                                : subClassification[
                                                                        i - 1]
                                                                    .name),
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
                                                Rx<OrderItem>? orderItem =
                                                    cashRegistryService
                                                        .orderController
                                                        .isProductInOrderItems(
                                                            products[i]);
                                                return InkWell(
                                                    onTap: () {
                                                      selectedProduct.value =
                                                          products[i];
                                                      if (!cashRegistryService
                                                          .orderController
                                                          .addOrderItem(
                                                              cashRegistryService
                                                                  .orderController
                                                                  .selectedOrder
                                                                  .value!
                                                                  .id,
                                                              products[i].sku,
                                                              1)) {
                                                        print(
                                                            'did not add order item');
                                                      }
                                                    },
                                                    child: Container(
                                                      color: orderItem != null
                                                          ? Colors.red
                                                          : Colors.green,
                                                      child: Center(
                                                          child: Text(
                                                              products[i]
                                                                  .name)),
                                                    ));
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
                                      cashRegistryService
                                          .navigateTo(CashRegistryModule.menu);
                                    },
                                    child: Container(
                                      color: Colors.red,
                                      height: double.infinity,
                                      width: 100,
                                      child: Center(
                                        child: Text(
                                          'EXIT',
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
                      )
                    : Expanded(
                        child: Container(
                          // width: double.infinity,
                          // height: double.infinity,
                          color: Color.fromARGB(255, 54, 54, 54),
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                '${selectedProduct.value?.name.capitalize}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              )
                            ],
                          ),
                        ),
                      )),
                GestureDetector(
                  onTap: () {
                    selectedProduct.value = null;
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
                              Expanded(
                                child: Obx(() => ListView.builder(
                                      itemCount: cashRegistryService
                                          .orderController.orderItems.length,
                                      // padding: EdgeInsets.all(10),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return ListTile(
                                          onTap: () {},
                                          title: Text(cashRegistryService
                                              .orderController
                                              .orderItems[index]
                                              .value
                                              .product
                                              .name),
                                          subtitle: Obx(() => Text(
                                              '${cashRegistryService.orderController.orderItems[index].value.quantity} * ${cashRegistryService.orderController.orderItems[index].value.product.price}')),
                                          trailing: Text(
                                            '₱ ${(double.parse(cashRegistryService.orderController.orderItems[index].value.product.price) * cashRegistryService.orderController.orderItems[index].value.quantity).toStringAsFixed(2)}',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        );
                                      },
                                    )),
                              ),
                              Container(
                                width: double.infinity,
                                height: 120,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Obx(() => Text(
                                          'Sub Total ₱ ${cashRegistryService.orderController.selectedOrder.value?.totalAmount.toStringAsFixed(2)}',
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
                                          'Total ₱ ${cashRegistryService.orderController.selectedOrder.value?.totalAmount.toStringAsFixed(2)}',
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
}
