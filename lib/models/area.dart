class Area {
  final BigInt id;
  final String name;
  final String code;
  final bool isActive;

  Area({
    required this.id,
    required this.name,
    required this.code,
    required this.isActive,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      id: BigInt.parse(json['id'].toString()),
      name: json['name'],
      code: json['code'],
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'name': name,
      'code': code,
      'is_active': isActive,
    };
  }
}
