import 'package:zwap_test/model/condition.dart';

class Post {
  final int id;
  final String title;
  final String description;
  final String status;
  final String createdAt;
  final Condition condition;

  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.condition,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      createdAt: json['created_at'],
      condition: Condition.fromJson(json['condition']),
    );
  }
}
