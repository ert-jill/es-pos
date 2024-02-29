import 'package:pos/utils/converter.dart';

class Account {
  BigInt id;
  String name;
  String ownerName;
  String email;
  String contactNumber;
  String address;
  bool status;

  Account({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.email,
    required this.contactNumber,
    required this.address,
    required this.status,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: Convert.parseToBigInt(json['id']) as BigInt,
      name: json['name'] as String,
      ownerName: json['ownerName'] as String,
      email: json['email'] as String,
      contactNumber: json['contactNumber'] as String,
      address: json['address'] as String,
      status: json['status'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'name': name,
      'ownerName': ownerName,
      'email': email,
      'contactNumber': contactNumber,
      'address': address,
      'status': status,
    };
  }
}
