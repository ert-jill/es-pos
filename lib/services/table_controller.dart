import 'dart:convert';
import 'package:get/get.dart';
import 'package:pos/models/form.dart';
import '../models/table.dart';
import 'http_service.dart';

class TableController extends GetxController {
  final HttpService httpService = Get.find<HttpService>();
  RxList<Rx<Table>> tableList = RxList.empty();

  getTableList() async {
    var response = await httpService.getRequest('tables/');
    if (response.isOk) {
      final List<dynamic> jsonList = jsonDecode(response.bodyString ?? '');
      List<Table> userListFromJson =
          jsonList.map((json) => Table.fromJson(json)).toList();
      tableList.value = userListFromJson.map((table) => table.obs).toList().obs;
      ;
    } else {
      tableList.value = [];
    }
    tableList.refresh();
  }

  getTables(String? area) async {
    var response = await httpService
        .getRequest('tables/${area != null ? '?area=$area' : ''}');
    if (response.isOk) {
      final List<dynamic> jsonList = jsonDecode(response.bodyString ?? '');
      List<Table> userListFromJson =
          jsonList.map((json) => Table.fromJson(json)).toList();
      tableList.value = userListFromJson.map((table) => table.obs).toList().obs;
      ;
    } else {
      tableList.value = [];
    }
    tableList.refresh();
  }

  Future<Response> addTable(TableFormModel tableFormModel) async {
    try {
      final response =
          await httpService.postRequest('tables/', tableFormModel.toJson());
      return response;
    } catch (e) {
      // Handle exceptions or errors here
      print('Exception occurred: $e');
      rethrow; // Rethrow the exception for further handling, if needed
    }
  }

  Future<Response> updateTable(TableFormModel tableFormModel) async {
    try {
      final response =
          await httpService.putRequest('tables/', tableFormModel.toJson());
      return response;
    } catch (e) {
      // Handle exceptions or errors here
      print('Exception occurred: $e');
      rethrow; // Rethrow the exception for further handling, if needed
    }
  }
}
