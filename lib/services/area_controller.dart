import 'dart:convert';

import 'package:get/get.dart';
import 'package:pos/models/form.dart';
import '../models/area.dart';
import 'http_service.dart';

class AreaController extends GetxController {
  final HttpService httpService = Get.find<HttpService>();
  RxList<Area> areaList = RxList.empty();

  getAreaList() async {
    var response = await httpService.getRequest('areas/');
    if (response.isOk) {
      final List<dynamic> jsonList = jsonDecode(response.bodyString ?? '');
      List<Area> userListFromJson =
          jsonList.map((json) => Area.fromJson(json)).toList();
      areaList.value = userListFromJson;
    } else {
      areaList.value = [];
    }
    areaList.refresh();
  }

  Future<Response> addArea(AreaFormModel areaFormModel) async {
    try {
      final response =
          await httpService.postRequest('areas/', areaFormModel.toJson());
      return response;
    } catch (e) {
      // Handle exceptions or errors here
      print('Exception occurred: $e');
      rethrow; // Rethrow the exception for further handling, if needed
    }
  }
}
