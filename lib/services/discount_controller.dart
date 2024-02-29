import 'dart:convert';

import 'package:get/get.dart';
import 'package:pos/models/form.dart';
import '../models/discount.dart';
import 'http_service.dart';

class DiscountController extends GetxController {
  final HttpService httpService = Get.find<HttpService>();

  RxList<Discount> discountList = RxList.empty();

  getDiscountList() async {
    var response = await httpService.getRequest('discounts/');
    if (response.isOk) {
      final List<dynamic> jsonList = jsonDecode(response.bodyString ?? '');
      List<Discount> discountListFromJson =
          jsonList.map((json) => Discount.fromJson(json)).toList();
      discountList.value = discountListFromJson;
    } else {
      discountList.value = [];
    }
    discountList.refresh();
  }

  Future<Response> addDiscount(DiscountFormModel discountFormModel) async {
    try {
      final response = await httpService.postRequest(
          'discounts/', discountFormModel.toJson());
      if (response.isOk) {
        getDiscountList();
      }
      return response;
    } catch (e) {
      // Handle exceptions or errors here
      print('Exception occurred: $e');
      rethrow; // Rethrow the exception for further handling, if needed
    }
  }
}
