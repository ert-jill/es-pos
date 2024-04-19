import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pos/models/form.dart';
import 'package:pos/services/user_service.dart';

import '../models/account.dart';
import '../models/order.dart';
import '../models/product.dart';
import 'http_service.dart';

class OrderController extends GetxController {
  final HttpService httpService = Get.find<HttpService>();
  late Rx<Order?> selectedOrder = Rx(null); //hold current selected order
  final UserService userService = Get.find<UserService>();
  RxList<Rx<OrderItem>> orderItems =
      RxList.empty(); //get order items of selected order

  selectOrder(BigInt orderId) async {
    selectedOrder.value = await getOrder(orderId);
    orderItems.value = await getOrderItems(orderId);
  }

  bool isProductInOrderItems(Product product) {
    return (orderItems.firstWhereOrNull((obj) =>
            obj.value.product.id == product.id && !obj.value.isPlaced) !=
        null);
  }

  printOrderReceipt() {
    Get.dialog(
      Material(
          color: Colors.transparent,
          child: Center(
              child: Container(
            padding: EdgeInsets.fromLTRB(0, 50, 0, 50),
            width: 350,
            child: Container(
                color: Colors.white,
                child: ListView(
                  padding: EdgeInsets.fromLTRB(10, 100, 10, 100),
                  children: [
                    Text(
                      'POS',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Kechin Store',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Capt. Leon St. Tapilon,\nDaanbantayan,\nCebu',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Contact : 09352769085',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Cashier : ${userService.user.value!.firstName} ${userService.user.value!.lastName}',
                    ),
                    ...orderItems
                        .map((element) => ListTile(
                              title: Text(
                                  '${element.value.id.toString().padLeft(8, '0')} - ${element.value.product.name}'),
                              subtitle: Text(
                                  '${element.value.quantity.toStringAsFixed(0)}'),
                              trailing: Text(
                                  '₱ ${(element.value.quantity * double.parse(element.value.product.price)).toStringAsFixed(2)}'),
                            ))
                        .toList(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal : '),
                        Text(
                            '₱ ${OrderController.getSumOfOrderItems(orderItems).toStringAsFixed(2)}')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Discount : '),
                        Text(
                            '₱ ${selectedOrder.value?.totalDiscount.toStringAsFixed(2)}')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total : '),
                        Text(
                            '₱ ${OrderController.getSumOfOrderItems(orderItems).toStringAsFixed(2)}')
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Thank You and Come again!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Like us on facebook & instagram:\nKichen Store',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '***OFFICIAL | RE-PRINT***\n***PARTIAL***',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )),
          ))),
    );
  }

  Future<Rx<OrderItem>> getOrderItem(Product product) async {
    List<Rx<OrderItem>> result = orderItems
        .where(
            (obj) => obj.value.product.id == product.id && !obj.value.isPlaced)
        .toList();
    if (result.length > 1) {
      Rx<OrderItem> res = await Get.dialog(Center(
        child: SizedBox(
          width: 800,
          height: 700,
          child: Material(
            color: Colors.transparent,
            child: GridView.builder(
                padding: EdgeInsets.all(10),
                itemCount: result.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3),
                itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        Get.back(result: result[index]);
                      },
                      child: Container(
                        color: Colors.red,
                        child: Center(
                          child: Text(
                            '${result[index].value.id.toString().padLeft(8, '0')}\n${result[index].value.product.name}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )),
          ),
        ),
      ));

      return res;
    } else {
      return result[0];
    }
  }

  Future<Order?> getOrder(BigInt id) async {
    var response = await httpService.getRequest('orders/$id/');
    if (response.isOk) {
      return Order.fromJson(response.body);
    } else {
      return null;
    }
  }

  Future<OrderItem?> setProductQuantity(
      BigInt order_item_id, double quantity) async {
    var response = await httpService.putRequest(
        'orders/set_order_item_quantity/?order_item=$order_item_id',
        {'quantity': quantity});
    if (response.isOk) {
      return OrderItem.fromJson(response.body);
    } else {
      return null;
    }
  }

  Future<List<Rx<OrderItem>>> getOrderItems(BigInt orderId) async {
    try {
      final response =
          await httpService.getRequest('orders/order_item_update/$orderId/');
      if (response.isOk) {
        final List<dynamic> jsonList = jsonDecode(response.bodyString ?? '');
        List<Rx<OrderItem>> orderItemListFromJson =
            jsonList.map((json) => OrderItem.fromJson(json).obs).toList();
        return orderItemListFromJson;
      } else {
        return [];
      }
    } catch (e) {
      // Handle exceptions or errors here
      print('Exception occurred: $e');
      rethrow; // Rethrow the exception for further handling, if needed
    }
  }

  //add order item
  Future<OrderItem?> addOrderItem(
      BigInt order_id, String product, int quantity) async {
    OrderItemFormModel orderItemFormModel = OrderItemFormModel();
    orderItemFormModel.order = order_id.toString();
    orderItemFormModel.product = product;
    orderItemFormModel.quantity = quantity.toString();
    OrderItem? orderItem = await addOrderItemRequest(orderItemFormModel);

    if (orderItem != null) {
      orderItems.add(orderItem.obs);
      orderItems.refresh();
      return orderItem;
    } else {
      return null;
    }
  }

  //sum of order items
  static double getSumOfOrderItems(RxList<Rx<OrderItem>> orderItems) {
    double sum = orderItems.fold(
        0,
        (previousValue, element) =>
            previousValue +
            (double.parse(element.value.product.price) *
                element.value.quantity));
    return sum;
  }

  // //
  // addItemQuantity(BigInt order, String sku) async {
  //   int foundOrder = orderItems
  //       .indexWhere((obj) => order == obj.value.order && obj.value.sku == sku);
  //   if (foundOrder != -1) {
  //     OrderItem? orderItem = await setProductQuantity(
  //         orderItems[foundOrder].value.id,
  //         orderItems[foundOrder].value.quantity + 1);
  //     if (orderItem != null) {
  //       orderItems[foundOrder].value.quantity = orderItem.quantity;
  //       orderItems[foundOrder].value.productTotal = orderItem.productTotal;
  //       orderItems[foundOrder].refresh();
  //     }
  //   }
  // }

  // removeItemQuantity(BigInt order, String sku) async {
  //   int foundOrder = orderItems
  //       .indexWhere((obj) => order == obj.value.order && obj.value.sku == sku);
  //   if (foundOrder != -1) {
  //     if (orderItems[foundOrder].value.quantity > 1) {
  //       OrderItem? orderItem = await setProductQuantity(
  //           orderItems[foundOrder].value.id,
  //           orderItems[foundOrder].value.quantity - 1);
  //       if (orderItem != null) {
  //         print('here i am');
  //         orderItems[foundOrder].value.quantity = orderItem.quantity;
  //         orderItems[foundOrder].value.productTotal = orderItem.productTotal;
  //         orderItems[foundOrder].refresh();
  //       }
  //     }
  //   }
  // }

  // indexOfProductInOrder(String sku) {
  //   int foundOrder = orderItems.indexWhere((obj) => obj.value.sku == sku);
  //   return foundOrder;
  // }

  Future<List<Order>> getOrderList() async {
    var response = await httpService.getRequest('orders/');
    if (response.isOk) {
      final List<dynamic> jsonList = jsonDecode(response.bodyString ?? '');
      List<Order> userListFromJson =
          jsonList.map((json) => Order.fromJson(json)).toList();
      return userListFromJson;
    } else {
      return [];
    }
  }

  Future<List<Order>> getOrders(String by) async {
    var response = await httpService.getRequest('orders/?by=$by');
    if (response.isOk) {
      final List<dynamic> jsonList = jsonDecode(response.bodyString ?? '');
      List<Order> userListFromJson =
          jsonList.map((json) => Order.fromJson(json)).toList();
      return userListFromJson;
    } else {
      return [];
    }
  }

  // /orders/add_order_item/
  Future<Response> createOrder(OrderFormModel orderFormModel) async {
    try {
      final response =
          await httpService.postRequest('orders/', orderFormModel.toJson());
      return response;
    } catch (e) {
      // Handle exceptions or errors here
      print('Exception occurred: $e');
      rethrow; // Rethrow the exception for further handling, if needed
    }
  }

  Future<OrderItem?> addOrderItemRequest(
      OrderItemFormModel orderItemFormModel) async {
    try {
      final response = await httpService.postRequest(
          'orders/order_item_create/', orderItemFormModel.toJson());
      if (response.isOk) {
        return OrderItem.fromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      // Handle exceptions or errors here
      print('Exception occurred: $e');
      rethrow; // Rethrow the exception for further handling, if needed
    }
  }

  getOrderTypes() async {
    var response = await httpService.getRequest('orders/get_account_type/');
    if (response.isOk) {
      final List<dynamic> jsonList = jsonDecode(response.bodyString ?? '');
      List<AccountType> accountTypeList =
          jsonList.map((json) => AccountType.fromJson(json)).toList();
      return accountTypeList;
    } else {
      return [];
    }
  }
}
