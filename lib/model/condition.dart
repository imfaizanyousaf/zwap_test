class Condition {
  final int id;
  final String name;
  final String description;

  Condition({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}