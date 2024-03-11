import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/cash_registry_service.dart';

class CashRegistryWidget extends StatelessWidget {
  CashRegistryService cashRegistryService = Get.put(CashRegistryService());

  CashRegistryWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => cashRegistryService
        .getModuleWidget(cashRegistryService.selectedModule.value));
  }
}
