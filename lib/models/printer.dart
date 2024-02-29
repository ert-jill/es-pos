class Printer {
  BigInt id;
  String name;
  String description;
  String connection;
  bool isActive;

  Printer({
    required this.id,
    required this.name,
    required this.description,
    required this.connection,
    required this.isActive,
  });

  factory Printer.fromJson(Map<String, dynamic> json) {
    return Printer(
      id: BigInt.from(json['id']),
      name: json['name'],
      description: json['description'],
      connection: json['connection'],
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'name': name,
      'description': description,
      'connection': connection,
      'is_active': isActive,
    };
  }
}
