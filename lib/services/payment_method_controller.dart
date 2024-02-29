import 'dart:convert';
import 'package:get/get.dart';
import 'package:pos/models/form.dart';
import '../models/payment_method.dart';
import 'http_service.dart';

class PaymentMethodController extends GetxController {
  final HttpService httpService = Get.find<HttpService>();
  RxList<PaymentMethod> paymentMethodList = RxList.empty();

  getPaymentMethodList() async {
    var response = await httpService.getRequest('payment_methods/');
    if (response.isOk) {
      final List<dynamic> jsonList = jsonDecode(response.bodyString ?? '');
      List<PaymentMethod> userListFromJson =
          jsonList.map((json) => PaymentMethod.fromJson(json)).toList();
      paymentMethodList.value = userListFromJson;
    } else {
      paymentMethodList.value = [];
    }
    paymentMethodList.refresh();
  }

  Future<Response> addPaymentMethod(
      PaymentMethodFormModel paymentMethodFormModel) async {
    try {
      final response = await httpService.postRequest(
          'payment_methods/', paymentMethodFormModel.toJson());
      return response;
    } catch (e) {
      // Handle exceptions or errors here
      print('Exception occurred: $e');
      rethrow; // Rethrow the exception for further handling, if needed
    }
  }
}
