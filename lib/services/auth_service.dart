// auth_service.dart
import 'package:get/get.dart';
import 'package:pos/constant.dart';
import 'package:pos/models/credential.dart';
import 'package:pos/services/http_service.dart';
import 'package:pos/services/storage_service.dart';

class AuthService extends GetxService {
  var access = ''.obs;
  final HttpService httpService = Get.find<HttpService>();
  final StorageService storageService = Get.find<StorageService>();

  @override
  Future<void> onInit() async {
    super.onInit();
    await checkLogged();
  }

  checkLogged() async {
    var acc = await storageService.get(AuthConstant.user);
    if (acc != null) {
      access.value = acc;
      print(' i am hererrrrrrr ${access.value}');
      Get.offAllNamed(RouteNames.start);
    }
  }

  Future<Response> login(LoginCredentials loginCredentials) async {
    // Perform login logic
    var responce = await httpService.postRequest(
        'users/login/', loginCredentials.toJson());
    if (responce.isOk == true) {
      storageService.set(AuthConstant.user, responce.bodyString);
      httpService.headers.addEntries([
        MapEntry('Authorization',
            'Bearer  ${responce.body['access_token']['access']}')
      ]);
      access.value = responce.body.toString();
    }
    return responce;
  }

  Future<void> logout() async {
    // Perform logout logic
    httpService.headers.remove('Authorization');
    await storageService.deleteAll();
    var acc = await storageService.get(AuthConstant.user);
    print('out $acc');
    access.value = '';
    await Get.offAllNamed(RouteNames.login);
  }
}
