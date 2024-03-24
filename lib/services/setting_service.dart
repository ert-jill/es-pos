import 'package:get/get.dart';

class SettingService extends GetxService {
  RxBool isVisibleAppbar = true.obs;

  setAppBarVisibility(bool visible) {
    isVisibleAppbar.value = visible;
  }
}
