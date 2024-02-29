import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/screens/product_form.dart';
import 'package:pos/screens/product_list.dart';
import 'package:pos/screens/user_form.dart';
import 'package:pos/screens/user_list.dart';

enum ProductModule { list, insert }

class ProductWidget extends StatelessWidget {
  Rx<ProductModule> selectedProductModule = ProductModule.list.obs;
  ProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Obx(() => SegmentedButton<ProductModule>(
              //       showSelectedIcon: false,
              //       segments: const <ButtonSegment<ProductModule>>[
              //         ButtonSegment<ProductModule>(
              //             value: ProductModule.list,
              //             label: Padding(
              //               padding: EdgeInsets.all(20),
              //               child: Text('List'),
              //             ),
              //             icon: Icon(Icons.list_outlined)),
              //         ButtonSegment<ProductModule>(
              //             value: ProductModule.insert,
              //             label: Padding(
              //               padding: EdgeInsets.all(20),
              //               child: Text('Add'),
              //             ),
              //             icon: Icon(Icons.person_add_outlined)),
              //       ],
              //       selected: <ProductModule>{selectedProductModule.value},
              //       onSelectionChanged: (newSelection) {
              //         selectedProductModule.value = newSelection.first;
              //       },
              //     )),
              Obx(() => getUserModuleWidget(selectedProductModule.value))
            ],
          ),
          floatingActionButton: FloatingActionButton.large(
            onPressed: () {
              // Add your onPressed code here!
              Get.dialog(Center(child: ProductForm()),
                  barrierDismissible: false);
            },
            child: const Icon(Icons.add),
          ),
        ));
  }

  getUserModuleWidget(ProductModule userModule) {
    switch (userModule) {
      case ProductModule.list:
        return ProductList();
      case ProductModule.insert:
        return UserForm();
    }
  }
}
