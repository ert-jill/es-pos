import 'dart:convert';

class Product {
  BigInt id;
  String sku;
  String name;
  String description;
  String price;
  int stocks;
  // List<Product> productItems;

  Product({
    required this.id,
    required this.sku,
    required this.name,
    required this.description,
    required this.price,
    required this.stocks,
    // required this.productItems,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // List<dynamic>? jsonList = jsonDecode(jsonEncode(json['product_items']));
    // List<Product>? productFromJson =
    //     jsonList?.map((json) => Product.fromJson(json)).toList();
    return Product(
      id: BigInt.parse(json['id'].toString()),
      sku: json['sku'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      stocks: json['stocks'],
      // productItems: productFromJson ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'sku': sku,
      'name': name,
      'description': description,
      'price': price,
      'stocks': stocks,
      // 'product_items': productItems,
    };
  }
}
