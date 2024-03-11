import 'dart:convert';

import 'package:get/get.dart';
import 'package:pos/models/classification.dart';
import 'package:pos/models/form.dart';
import 'http_service.dart';

class ClassificationController extends GetxController {
  final HttpService httpService = Get.find<HttpService>();

  RxList<Classification> classificationList = RxList.empty();

  getClassificationList(String? parent, String? depth) async {
    var response = await httpService.getRequest(
        'classifications/${parent != null ? '?parent=$parent' : ''}${depth != null ? '?depth=$depth' : ''}');
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

  getClassificationList1(String? parent, String? depth) async {
    var response = await httpService.getRequest(
        'classifications/${parent != null || depth != null ? '?' : ''}${parent != null ? 'parent=$parent' : ''}${depth != null && parent != null ? '&' : ''}${depth != null ? 'depth=$depth' : ''}');
    if (response.isOk) {
      final List<dynamic> jsonList = jsonDecode(response.bodyString ?? '');
      List<Classification> classificationListFromJson =
          jsonList.map((json) => Classification.fromJson(json)).toList();
      classificationList.value = classificationListFromJson;
      return classificationListFromJson;
    }
    return [];
  }

  Future<Response> addClassification(
      ClassificationFormModel classificationFormModel) async {
    try {
      final response = await httpService.postRequest(
          'classifications/', classificationFormModel.toJson());
      if (response.isOk) {
        getClassificationList(null, null);
      }
      return response;
    } catch (e) {
      // Handle exceptions or errors here
      print('Exception occurred: $e');
      rethrow; // Rethrow the exception for further handling, if needed
    }
  }
}
