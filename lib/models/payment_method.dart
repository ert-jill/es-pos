class PaymentMethod {
  BigInt id;
  String name;
  String type;
  String description;
  String accountNumber;

  PaymentMethod(
      {required this.id,
      required this.name,
      required this.type,
      required this.description,
      required this.accountNumber});

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: BigInt.parse(json['id'].toString()),
      name: json['name'],
      type: json['type'],
      description: json['description'],
      accountNumber: json['account_number'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id.toString();
    data['name'] = this.name;
    data['type'] = this.type;
    data['description'] = this.description;
    data['account_number'] = this.accountNumber;
    return data;
  }
}
