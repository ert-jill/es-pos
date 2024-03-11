import 'dart:convert';

import 'package:get/get.dart';
import 'package:pos/models/form.dart';
import '../models/product.dart';
import 'http_service.dart';

class ProductService extends GetxService {
  final HttpService httpService = Get.find<HttpService>();
  RxList<Product> productList = RxList.empty();

  getProductList(String? stringSearch) async {
    var response = await httpService.getRequest(stringSearch == null
        ? 'products/'
        : 'products/?product_name=$stringSearch');
    if (response.isOk) {
      final List<dynamic> jsonList =
          jsonDecode(jsonEncode(response.body['results']) ?? '');
      List<Product> productFromJson =
          jsonList.map((json) => Product.fromJson(json)).toList();
      productList.value = productFromJson;
    } else {
      productList.value = [];
    }
    productList.refresh();
  }

  Future<List<Product>> searchProducts(
      String? stringSearch, String? classification, String? page) async {
    var response = await httpService.getRequest(
        'products/${stringSearch != null || page != null || classification != null ? '?' : ''}${page != null ? 'page=' + page : ''}${page != null && (stringSearch != null || classification != null) ? '&' : ''}${stringSearch != null ? 'product_name=' + stringSearch : ''}${stringSearch != null && page != null && classification != null ? '&' : ''}${classification != null ? 'classification=' + classification : ''}');

    final List<dynamic> jsonList =
        jsonDecode(jsonEncode(response.body['results']) ?? '');
    List<Product> productFromJson =
        jsonList.map((json) => Product.fromJson(json)).toList();

    return productFromJson;
  }

  Future<Response> addProduct(ProductFormModel accountFormModel) async {
    try {
      final response =
          await httpService.postRequest('products/', accountFormModel.toJson());
      return response;
    } catch (e) {
      // Handle exceptions or errors here
      print('Exception occurred: $e');
      rethrow; // Rethrow the exception for further handling, if needed
    }
  }
}
