import 'dart:convert';

import 'package:get/get.dart';
import 'package:pos/utils/converter.dart';

import '../models/user_type.dart';
import 'http_service.dart';

class UserTypeConroller extends GetxController {
  final HttpService httpService = Get.find<HttpService>();
  RxList<UserType> userTypeList = RxList.empty();

  getUserTypes() async {
    var response = await httpService.getRequest('user_types/');
    if (response.isOk) {
      print(response.bodyString);
      final List<dynamic> jsonList = json.decode(response.bodyString ?? '');
      List<UserType> userTypeListFromJson =
          jsonList.map((json) => UserType.fromJson(json)).toList();
      userTypeList.value = userTypeListFromJson;
      userTypeListFromJson.forEach((element) {
        print(element.toJson().toString());
      });
      print(jsonList.length);
    } else {
      userTypeList.value = [];
    }
    userTypeList.refresh();
  }
}
