class Locations {
  int id;
  String name;
  String type;
  int? parentId;
  DateTime createdAt;
  DateTime updatedAt;

  Locations({
    required this.id,
    required this.name,
    required this.type,
    this.parentId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Locations.fromJson(Map<String, dynamic> json) {
    return Locations(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      parentId: json['parent_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'parent_id': parentId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
