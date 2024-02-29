import 'dart:convert';
import 'package:get/get.dart';
import 'package:pos/models/form.dart';
import '../models/printer.dart';
import 'http_service.dart';

class PrinterController extends GetxController {
  final HttpService httpService = Get.find<HttpService>();
  RxList<Printer> printerList = RxList.empty();

  getPrinterList() async {
    var response = await httpService.getRequest('printers/');
    if (response.isOk) {
      final List<dynamic> jsonList = jsonDecode(response.bodyString ?? '');
      List<Printer> printerListFromJson =
          jsonList.map((json) => Printer.fromJson(json)).toList();
      printerList.value = printerListFromJson;
    } else {
      printerList.value = [];
    }
    printerList.refresh();
  }

  Future<Response> addPrinter(PrinterFormModel printerFormModel) async {
    try {
      final response =
          await httpService.postRequest('printers/', printerFormModel.toJson());
      return response;
    } catch (e) {
      // Handle exceptions or errors here
      print('Exception occurred: $e');
      rethrow; // Rethrow the exception for further handling, if needed
    }
  }
}
