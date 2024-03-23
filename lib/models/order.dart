import 'product.dart';

class Order {
  BigInt id;
  double totalAmount;
  double totalVat;
  double totalDiscount;
  String? customer; // Nullable customer field
  bool isVoid;
  DateTime createdDate;
  DateTime? updatedDate;
  int status;
  BigInt account;
  int? table;
  int? isVoidByUser;
  int createdbyUser;
  int? updatedByUser;

  Order({
    required this.id,
    required this.totalAmount,
    required this.totalVat,
    required this.totalDiscount,
    this.customer,
    required this.isVoid,
    required this.createdDate,
    this.updatedDate,
    required this.status,
    required this.account,
    this.table,
    this.isVoidByUser,
    required this.createdbyUser,
    this.updatedByUser,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: BigInt.parse(json['id'].toString()),
      totalAmount: double.parse(json['total_amount']),
      totalVat: double.parse(json['total_vat']),
      totalDiscount: double.parse(json['total_discount']),
      customer: json['customer'], // Nullable customer field
      isVoid: json['is_void'],
      createdDate: DateTime.parse(json['created_date']),
      updatedDate: json['updated_date'] != null
          ? DateTime.parse(json['updated_date'])
          : null,
      status: json['status'],
      account: BigInt.parse(json['account'].toString()),
      table: json['table'],
      isVoidByUser: json['is_void_by_user'],
      createdbyUser: json['created_by_user'],
      updatedByUser: json['updated_by_user'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id.toString();
    data['total_amount'] = this.totalAmount.toStringAsFixed(2);
    data['total_vat'] = this.totalVat.toStringAsFixed(2);
    data['total_discount'] = this.totalDiscount.toStringAsFixed(2);
    data['customer'] = this.customer; // Nullable customer field
    data['is_void'] = this.isVoid;
    data['created_date'] = this.createdDate.toIso8601String();
    data['updated_date'] = this.updatedDate?.toIso8601String();
    data['status'] = this.status;
    data['account'] = this.account.toString();
    data['table'] = this.table;
    data['is_void_by_user'] = this.isVoidByUser;
    data['created_by_user'] = this.createdbyUser;
    data['updated_by_user'] = this.updatedByUser;
    return data;
  }
}

class OrderItem {
  BigInt id;
  // String? sku;
  BigInt order;
  Product product;
  double quantity;
  // String productTotal;
  // String productDiscount;
  bool isVoid;
  bool isPlaced;

  OrderItem({
    // this.sku,
    required this.id,
    required this.order,
    required this.product,
    required this.quantity,
    // required this.productTotal,
    // required this.productDiscount,
    required this.isVoid,
    required this.isPlaced,
  });

  @override
  bool operator ==(other) {
    return other is OrderItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
        id: BigInt.from(json['id']),
        // sku: json['sku'],
        order: BigInt.parse(json['order'].toString()),
        product: Product.fromJson(json['product']),
        quantity: double.parse(json['quantity']),
        // productTotal: json['product_total'],
        // productDiscount: json['product_discount'],
        isVoid: json['is_void'],
        isPlaced: json['is_placed']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order': order,
      'product': product.toJson(),
      'quantity': quantity.toString(),
      // 'product_total': productTotal,
      // 'product_discount': productDiscount,
      'is_void': isVoid,
      'is_placed': isPlaced
    };
  }
}
