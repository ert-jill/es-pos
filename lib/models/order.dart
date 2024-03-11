import 'product.dart';

class Order {
  final BigInt id;
  final bool isVoid;
  final String total;
  final String totalDiscount;
  final String customer;
  final String orderStatus;
  final String? tables; // concatinated id of tables if merge table

  Order({
    required this.id,
    required this.isVoid,
    required this.total,
    required this.totalDiscount,
    required this.customer,
    required this.orderStatus,
    required this.tables,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: BigInt.from(json['id']),
      isVoid: json['is_void'],
      total: json['total'],
      totalDiscount: json['total_discount'],
      customer: json['customer'],
      orderStatus: json['order_status'],
      tables: json['tables'],
    );
  }
}

class OrderItem {
  BigInt id;
  String? sku;
  BigInt order;
  Product product;
  double quantity;
  String productTotal;
  String productDiscount;
  bool isVoid;

  OrderItem({
    this.sku,
    required this.id,
    required this.order,
    required this.product,
    required this.quantity,
    required this.productTotal,
    required this.productDiscount,
    required this.isVoid,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: BigInt.from(json['id']),
      sku: json['sku'],
      order: BigInt.parse(json['order'].toString()),
      product: Product.fromJson(json['product']),
      quantity: double.parse(json['quantity']),
      productTotal: json['product_total'],
      productDiscount: json['product_discount'],
      isVoid: json['is_void'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'order': order,
      'product': product.toJson(),
      'quantity': quantity.toString(),
      'product_total': productTotal,
      'product_discount': productDiscount,
      'is_void': isVoid,
    };
  }
}
