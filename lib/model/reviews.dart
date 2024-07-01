import 'package:zwap_test/model/post.dart';

class Reviews {
  int id;
  int rating; // Changed to int
  String comment;
  int feedbackOn;
  Map<String, dynamic> feedbackBy;
  Map<String, dynamic> feedbackTo;
  DateTime createdAt;
  DateTime updatedAt;
  Post post;

  Reviews({
    required this.id,
    required this.rating, // Changed to int
    required this.comment,
    required this.feedbackOn,
    required this.feedbackBy,
    required this.feedbackTo,
    required this.createdAt,
    required this.updatedAt,
    required this.post,
  });

  factory Reviews.fromJson(Map<String, dynamic> json) {
    return Reviews(
      id: json['id'],
      rating: json['rating'], // Parsing as int
      comment: json['comment'],
      feedbackOn: json['feedback_on'],
      feedbackBy: Map<String, dynamic>.from(json['feedback_by']),
      feedbackTo: Map<String, dynamic>.from(json['feedback_to']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      post: Post.fromJson(json['post']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating': rating, // Changed to int
      'comment': comment,
      'feedback_on': feedbackOn,
      'feedback_by': feedbackBy,
      'feedback_to': feedbackTo,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'post': post.toJson(),
    };
  }
}
