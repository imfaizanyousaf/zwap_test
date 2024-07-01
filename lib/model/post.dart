import 'package:zwap_test/model/categories.dart';
import 'package:zwap_test/model/conditions.dart';
import 'package:zwap_test/model/locations.dart';
import 'package:zwap_test/model/user.dart';

class Post {
  int? id;
  String title;
  String description;
  int userId;
  int conditionId;
  DateTime? publishedAt;
  DateTime? exchangedAt;
  bool? published;
  List<dynamic>? images;
  List<dynamic>? imageUrls;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;
  Conditions? condition;
  List<Locations>? locations;
  List<Categories>? categories;

  Post({
    this.id,
    required this.title,
    required this.description,
    required this.userId,
    required this.conditionId,
    this.published,
    this.publishedAt,
    this.images,
    this.exchangedAt,
    this.imageUrls,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.condition,
    this.locations,
    this.categories,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      userId: json['user_id'],
      conditionId: json['condition_id'],
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'])
          : null,
      exchangedAt: json['exchanged_at'] != null
          ? DateTime.parse(json['exchanged_at'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      imageUrls: json['image_urls'] == [] || json['image_urls'] == null
          ? [
              "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg"
            ]
          : json['image_urls'],
      condition: json['condition'] != null
          ? Conditions.fromJson(json['condition'])
          : null,
      locations: json['locations'] != null && json['locations'] is List
          ? List<Locations>.from(
              json['locations'].map((location) => Locations.fromJson(location)))
          : null,
      categories: json['categories'] != null && json['categories'] is List
          ? List<Categories>.from(json['categories']
              .map((category) => Categories.fromJson(category)))
          : null,
      published: json['published'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'user_id': userId,
      'condition_id': conditionId,
      'image_urls': imageUrls,
      'published': published,
      'published_at': publishedAt?.toIso8601String(),
      'exchanged_at': exchangedAt?.toIso8601String(),
      'user': user?.toJson(),
      'condition': condition?.toJson(),
      'locations': locations?.map((e) => e.id).toList(),
      'categories': categories?.map((e) => e.id).toList(),
    };
  }
}
