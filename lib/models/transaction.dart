class Transaction {
  final BigInt id;
  final String table;
  final String customer;
  final double totalAmount;
  final double totalVat;
  final double totalDiscount;
  final String transactionStatus;

  Transaction({
    required this.id,
    required this.table,
    required this.customer,
    required this.totalAmount,
    required this.totalVat,
    required this.totalDiscount,
    required this.transactionStatus,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: BigInt.parse(json['id'].toString()),
      table: json['table'],
      customer: json['customer'],
      totalAmount: double.parse(json['total_amount']),
      totalVat: double.parse(json['total_vat']),
      totalDiscount: double.parse(json['total_discount']),
      transactionStatus: json['transaction_status'],
    );
  }
}
