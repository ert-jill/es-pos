import 'dart:async';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TimeController extends GetxController {
  var currentTime = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _updateTime();
  }

  void _updateTime() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      currentTime.value = DateFormat('hh:mm:ss a')
          .format(DateTime.now()); // Update current time
    });
  }
}
