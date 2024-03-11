import 'dart:convert';

import 'package:get/get.dart';
import 'package:pos/models/form.dart';

import '../models/account.dart';
import '../models/order.dart';
import '../models/product.dart';
import 'http_service.dart';

class OrderController extends GetxController {
  final HttpService httpService = Get.find<HttpService>();
  late Rx<Order?> selectedOrder = Rx(null); //hold current selected order
  RxList<Rx<OrderItem>> orderItems =
      RxList.empty(); //get order items of selected order

  selectOrder(BigInt orderId) async {
    selectedOrder.value = await getOrder(orderId);
    orderItems.value = await getOrderItems(orderId);
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
          await httpService.getRequest('orders/get_order_item/?order=$orderId');
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
  addOrderItem(BigInt order_id, Product product, int quantity) async {
    int foundOrder =
        orderItems.indexWhere((obj) => obj.value.sku == product.sku);
    if (foundOrder > -1) {
      addItemQuantity(order_id, product.sku);
    } else {
      OrderItemFormModel orderItemFormModel = OrderItemFormModel();
      orderItemFormModel.order = order_id.toString();
      orderItemFormModel.sku = product.sku;
      orderItemFormModel.quantity = quantity.toString();
      OrderItem? orderItem = await addOrderItemRequest(orderItemFormModel);

      if (orderItem != null) {
        orderItems.add(orderItem.obs);
        orderItems.refresh();
      }
    }
  }

  //
  addItemQuantity(BigInt order, String sku) async {
    int foundOrder = orderItems
        .indexWhere((obj) => order == obj.value.order && obj.value.sku == sku);
    if (foundOrder != -1) {
      OrderItem? orderItem = await setProductQuantity(
          orderItems[foundOrder].value.id,
          orderItems[foundOrder].value.quantity + 1);
      if (orderItem != null) {
        orderItems[foundOrder].value.quantity = orderItem.quantity;
        orderItems[foundOrder].value.productTotal = orderItem.productTotal;
        orderItems[foundOrder].refresh();
      }
    }
  }

  removeItemQuantity(BigInt order, String sku) async {
    int foundOrder = orderItems
        .indexWhere((obj) => order == obj.value.order && obj.value.sku == sku);
    if (foundOrder != -1) {
      if (orderItems[foundOrder].value.quantity > 1) {
        OrderItem? orderItem = await setProductQuantity(
            orderItems[foundOrder].value.id,
            orderItems[foundOrder].value.quantity - 1);
        if (orderItem != null) {
          print('here i am');
          orderItems[foundOrder].value.quantity = orderItem.quantity;
          orderItems[foundOrder].value.productTotal = orderItem.productTotal;
          orderItems[foundOrder].refresh();
        }
      }
    }
  }

  indexOfProductInOrder(String sku) {
    int foundOrder = orderItems.indexWhere((obj) => obj.value.sku == sku);
    return foundOrder;
  }

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
          'orders/add_order_item/', orderItemFormModel.toJson());
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
