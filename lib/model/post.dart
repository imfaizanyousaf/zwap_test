import 'package:zwap_test/model/conditions.dart';
import 'package:zwap_test/model/user.dart';

class Post {
  int id;
  String title;
  String description;
  int userId;
  int conditionId;
  List<dynamic> images;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  User user;
  Conditions condition;
  List<dynamic> locations;

  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.userId,
    required this.conditionId,
    required this.images,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.condition,
    required this.locations,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      userId: json['user_id'],
      conditionId: json['condition_id'],
      images: json['images'] != null && json['images'] is List
          ? List<dynamic>.from(json['images'])
          : ['https://placehold.co/600x400'],
      status: json['status'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      user: User.fromJson(json['user']),
      condition: Conditions.fromJson(json['condition']),
      locations: json['locations'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'user_id': userId,
      'condition_id': conditionId,
      'images': images,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user': user.toJson(),
      'condition': condition.toJson(),
      'locations': locations,
    };
  }
}
