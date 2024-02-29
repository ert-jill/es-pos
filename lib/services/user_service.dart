import 'dart:convert';

import 'package:get/get.dart';
import 'package:pos/models/account.dart';
import 'package:pos/models/form.dart';
import 'package:pos/models/user.dart';
import 'package:pos/models/user_type.dart';
import 'package:pos/services/http_service.dart';
import 'package:pos/services/storage_service.dart';

import '../constant.dart';

class UserService extends GetxService {
  final HttpService httpService = Get.find<HttpService>();
  final StorageService storageService = Get.find<StorageService>();
  RxList<Account> userAccounts = RxList.empty();
  RxList<UserType> userTypes = RxList.empty();
  RxList<User> userList = RxList.empty();
  Rx<User?> user = Rx(null);
  // Rx<Account?> userSelectedAccount = Rx(null);

  @override
  Future<void> onInit() async {
    super.onInit();
    var userDetailString = await storageService.get(AuthConstant.user_details);
    // var userSelectedAccountString =
    //     await storageService.get(AuthConstant.user_selected_account);
    //check if user detail is available cosidered as logged In
    if (userDetailString != null) {
      user.value = User.fromJson(jsonDecode(userDetailString));
    }
    //check if user not yet selected any account
    // if (userSelectedAccountString != null) {
    //   userSelectedAccount.value =
    //       Account.fromJson(jsonDecode(userSelectedAccountString));
    //   Get.offAllNamed(RouteNames.start);
    // }
  }

  selectUserAccount(Account account) async {
    // userSelectedAccount.value = account;
    // storageService.set(AuthConstant.user_selected_account, jsonEncode(account));
    // userSelectedAccount.refresh();
    Get.offNamed(RouteNames.start);
  }

  getUserDetails() async {
    var response = await httpService.getRequest('users/get_user_details/');
    if (response.isOk) {
      var userJson = jsonDecode(response.bodyString ?? '');
      user.value = User.fromJson(userJson);
      storageService.set(AuthConstant.user_details, jsonEncode(userJson));
    }
    print(user.value!.toJson().toString());
    user.refresh();
  }

  getUserAcounts() async {
    var response = await httpService.getRequest('users/get_user_accounts/');
    if (response.isOk) {
      final List<dynamic> jsonList = jsonDecode(response.bodyString ?? '');
      List<Account> userAccountList =
          jsonList.map((json) => Account.fromJson(json)).toList();
      userAccounts.value = userAccountList;
    } else {
      userAccounts.value = [];
    }
    userAccounts.refresh();
  }

  getUserTypes() async {
    var response = await httpService.getRequest('user_types/');
    if (response.isOk) {
      final List<dynamic> jsonList = jsonDecode(response.bodyString ?? '');
      List<UserType> userTypeList =
          jsonList.map((json) => UserType.fromJson(json)).toList();
      userTypes.value = userTypeList;
    } else {
      userTypes.value = [];
    }
    userTypes.refresh();
  }

  Future<Response> addUserType(UserTypeFormModel userTypeFormModel) async {
    try {
      final response = await httpService.postRequest(
          'user_types/', userTypeFormModel.toJson());
      return response;
    } catch (e) {
      // Handle exceptions or errors here
      print('Exception occurred: $e');
      rethrow; // Rethrow the exception for further handling, if needed
    }
  }

  getUserList() async {
    var response = await httpService.getRequest('users/get_user_list/');
    if (response.isOk) {
      final List<dynamic> jsonList = jsonDecode(response.bodyString ?? '');
      List<User> userListFromJson =
          jsonList.map((json) => User.fromJson(json)).toList();
      userList.value = userListFromJson;
    } else {
      userList.value = [];
    }
    userList.refresh();
  }

  Future<Response> signUpUser(UserFormModel userFormData) async {
    try {
      final response =
          await httpService.postRequest('users/signup/', userFormData.toJson());
      return response;
    } catch (e) {
      // Handle exceptions or errors here
      print('Exception occurred: $e');
      rethrow; // Rethrow the exception for further handling, if needed
    }
  }
}
