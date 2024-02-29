import 'area.dart';

class Table {
  final BigInt id;
  final String name;
  final String code;
  final bool isActive;
  final Area area;

  Table({
    required this.id,
    required this.name,
    required this.code,
    required this.isActive,
    required this.area,
  });

  factory Table.fromJson(Map<String, dynamic> json) {
    return Table(
      id: BigInt.parse(json['id'].toString()),
      name: json['name'],
      code: json['code'],
      isActive: json['is_active'],
      area: Area.fromJson(json['area']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'name': name,
      'code': code,
      'is_active': isActive,
      'area': area,
    };
  }
}
