import 'dart:convert';

import 'package:get/get.dart';
import 'package:pos/models/classification.dart';
import 'package:pos/models/form.dart';
import 'http_service.dart';

class ClassificationController extends GetxController {
  final HttpService httpService = Get.find<HttpService>();

  RxList<Classification> classificationList = RxList.empty();

  getAccountList() async {
    var response = await httpService.getRequest('classifications/');
    if (response.isOk) {
      final List<dynamic> jsonList = jsonDecode(response.bodyString ?? '');
      List<Classification> classificationListFromJson =
          jsonList.map((json) => Classification.fromJson(json)).toList();
      classificationList.value = classificationListFromJson;
    } else {
      classificationList.value = [];
    }
    classificationList.refresh();
  }

  Future<Response> addClassification(
      ClassificationFormModel classificationFormModel) async {
    try {
      final response = await httpService.postRequest(
          'classifications/', classificationFormModel.toJson());
      if (response.isOk) {
        getAccountList();
      }
      return response;
    } catch (e) {
      // Handle exceptions or errors here
      print('Exception occurred: $e');
      rethrow; // Rethrow the exception for further handling, if needed
    }
  }
}
