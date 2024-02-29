import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingService {
  presentLoading() async {
    await Get.dialog(
      Center(
        child: Material(
          child: Container(
            width: 350,
            height: 250,
            color: Colors.white,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Loading...')
                ]),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  dismissLoading() {
    Get.back(closeOverlays: true);
  }
}
