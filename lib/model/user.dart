class User {
  int id;
  String firstName;
  String lastName;
  String email;
  DateTime emailVerifiedAt;
  DateTime createdAt;
  DateTime updatedAt;
  List<dynamic> messages;
  List<dynamic> notifications;
  List<dynamic> requests;
  List<dynamic> posts;
  List<dynamic> feedbacks;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.messages,
    required this.notifications,
    required this.requests,
    required this.posts,
    required this.feedbacks,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      emailVerifiedAt: DateTime.parse(json['email_verified_at']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      messages: json['messages'],
      notifications: json['notifications'],
      requests: json['requests'],
      posts: json['posts'],
      feedbacks: json['feedbacks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'email_verified_at': emailVerifiedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'messages': messages,
      'notifications': notifications,
      'requests': requests,
      'posts': posts,
      'feedbacks': feedbacks,
    };
  }
}
