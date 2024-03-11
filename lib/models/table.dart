import 'area.dart';

class Table {
  final BigInt id;
  final String name;
  final BigInt? order;
  final String code;
  final bool isActive;
  final Area area;
  double left;
  double top;

  Table({
    required this.id,
    required this.name,
    required this.code,
    required this.order,
    required this.isActive,
    required this.area,
    required this.left,
    required this.top,
  });

  factory Table.fromJson(Map<String, dynamic> json) {
    return Table(
      id: BigInt.parse(json['id'].toString()),
      name: json['name'],
      code: json['code'],
      order:
          json['order'] != null ? BigInt.parse(json['order'].toString()) : null,
      isActive: json['is_active'],
      left: double.parse(json['left']),
      top: double.parse(json['top']),
      area: Area.fromJson(json['area']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'name': name,
      'code': code,
      'order': order?.toString(),
      'is_active': isActive,
      'area': area,
      'top': top,
      'left': left,
    };
  }
}
