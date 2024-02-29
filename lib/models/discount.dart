class Discount {
  BigInt id;
  String name;
  String code;
  String description;
  String amount;
  String amountType;
  bool isActive;
  String? expiryDate;
  String? discountedProduct;
  BigInt account;

  Discount({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.amount,
    required this.amountType,
    required this.isActive,
    this.expiryDate,
    this.discountedProduct,
    required this.account,
  });

  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      id: BigInt.from(json['id']),
      name: json['name'],
      code: json['code'],
      description: json['description'],
      amount: json['amount'],
      amountType: json['amount_type'],
      isActive: json['is_active'],
      expiryDate: json['expiry_date'] != null ? json['expiry_date'] : null,
      discountedProduct: json['discounted_product'],
      account: BigInt.from(json['account']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'name': name,
      'code': code,
      'description': description,
      'amount': amount,
      'amount_type': amountType,
      'is_active': isActive,
      'expiry_date': expiryDate,
      'discounted_product': discountedProduct,
      'account': account,
    };
  }
}
