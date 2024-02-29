import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/models/product.dart';

import '../services/product_service.dart';
import '../services/user_service.dart';

class ProductList extends StatelessWidget {
  final ProductService productService = Get.find<ProductService>();
  ProductList({super.key});
  RxBool isLoading = false.obs;

  onInit() async {
    isLoading.value = true;
    await productService.getProductList(null);
    isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    onInit();
    return Expanded(
      child: Obx(() => isLoading.value
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: productService.productList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.person_outlined),
                        ),
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        onTap: () {},
                        isThreeLine: true,
                        subtitle: Text(
                            '${productService.productList[index].description}'),
                        trailing:
                            Text('${productService.productList[index].price}'),
                        title: Text(
                            '${productService.productList[index].sku ?? ''} ${productService.productList[index].name ?? ''} ${productService.productList[index].stocks ?? ''}'),
                      ),
                    ),
                    Divider()
                  ],
                );
              })),
    );
  }
}
