import '../utils/converter.dart';

class UserType {
  final BigInt id;
  final String name;
  final String description;
  final bool isActive;

  UserType({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
  });

  factory UserType.fromJson(Map<String, dynamic> json) {
    return UserType(
      id: Convert.parseToBigInt(json['id']),
      name: json['name'],
      description: json['description'],
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id as BigInt;
    data['name'] = this.name as String;
    data['description'] = this.description as String;
    data['is_active'] = this.isActive as bool;
    return data;
  }
}
