import 'dart:convert';

import 'package:get/get.dart';
import 'package:pos/models/form.dart';

import '../models/account.dart';
import 'http_service.dart';

class AccountController extends GetxController {
  final HttpService httpService = Get.find<HttpService>();
  RxList<Account> accountList = RxList.empty();

  getAccountList() async {
    var response = await httpService.getRequest('accounts/');
    if (response.isOk) {
      final List<dynamic> jsonList = jsonDecode(response.bodyString ?? '');
      List<Account> userListFromJson =
          jsonList.map((json) => Account.fromJson(json)).toList();
      accountList.value = userListFromJson;
    } else {
      accountList.value = [];
    }
    accountList.refresh();
  }

  Future<Response> addAccount(AccountFormModel accountFormModel) async {
    try {
      final response =
          await httpService.postRequest('accounts/', accountFormModel.toJson());
      return response;
    } catch (e) {
      // Handle exceptions or errors here
      print('Exception occurred: $e');
      rethrow; // Rethrow the exception for further handling, if needed
    }
  }

  getAccountTypes() async {
    var response = await httpService.getRequest('accounts/get_account_type/');
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
