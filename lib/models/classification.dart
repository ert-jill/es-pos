class Classification {
  BigInt id;
  String name;
  String description;
  BigInt? parent;
  int depth;

  Classification({
    required this.id,
    required this.name,
    required this.description,
    required this.parent,
    required this.depth,
  });

  factory Classification.fromJson(Map<String, dynamic> json) {
    return Classification(
      id: BigInt.from(json['id']),
      name: json['name'],
      description: json['description'],
      parent: json['parent'] != null ? BigInt.from(json['parent']) : null,
      depth: json['depth'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'name': name,
      'description': description,
      'parent': parent != null ? parent.toString() : null,
      'depth': depth,
    };
  }
}
