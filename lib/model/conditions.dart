class Conditions {
  final int id;
  final String name;
  final String description;

  Conditions({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Conditions.fromJson(Map<String, dynamic> json) {
    return Conditions(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
