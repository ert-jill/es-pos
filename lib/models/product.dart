class Product {
  BigInt id;
  String sku;
  String name;
  String description;
  String price;
  int stocks;

  Product({
    required this.id,
    required this.sku,
    required this.name,
    required this.description,
    required this.price,
    required this.stocks,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: BigInt.parse(json['id'].toString()),
      sku: json['sku'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      stocks: json['stocks'],
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
    };
  }
}
