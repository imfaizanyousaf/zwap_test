import 'package:zwap_test/model/post.dart';

class User {
  int id;
  String firstName;
  String lastName;
  String email;
  DateTime? emailVerifiedAt;
  DateTime createdAt;
  DateTime updatedAt;
  String? logo;
  List<dynamic>? messages;
  List<dynamic>? notifications;
  List<dynamic>? requests;
  List<Post>? posts;
  List<dynamic>? feedbacks;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.messages,
    required this.notifications,
    required this.requests,
    required this.posts,
    required this.feedbacks,
    this.logo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    print("USER AVAtAR: ${json['id']} : ${json['logo']}");
    return User(
        id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        email: json['email'],
        emailVerifiedAt: json['email_verified_at'] != null
            ? DateTime.parse(json['email_verified_at'])
            : null,
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        messages: json['messages'],
        notifications: json['notifications'],
        requests: json['requests'],
        posts: json['posts'] != null
            ? List<Post>.from(json['posts'].map((post) => Post.fromJson(post)))
            : [],
        feedbacks: json['feedbacks'],
        logo: json['logo']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'messages': messages,
      'notifications': notifications,
      'requests': requests,
      'posts': posts,
      'feedbacks': feedbacks,
      'logo': logo,
    };
  }
}
