import 'package:zwap_test/model/post.dart';
import 'package:zwap_test/model/user.dart';

class Request {
  int id;
  int requestedPostId;
  int exchangePostId;
  User requestedBy;
  String requestMessage;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  Post requestedPost;
  Post exchangedPost;

  Request({
    required this.id,
    required this.requestedPostId,
    required this.exchangePostId,
    required this.requestedBy,
    required this.requestMessage,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.requestedPost,
    required this.exchangedPost,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'],
      requestedPostId: json['requested_post_id'],
      exchangePostId: json['exchange_post_id'],
      requestedBy: User.fromJson(json['requested_by']),
      requestMessage: json['request_message'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      requestedPost: Post.fromJson(json['requested_post']),
      exchangedPost: Post.fromJson(json['exchanged_post']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'requested_post_id': requestedPostId,
      'exchange_post_id': exchangePostId,
      'requested_by': requestedBy.toJson(),
      'request_message': requestMessage,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'requested_post': requestedPost.toJson(),
      'exchanged_post': exchangedPost.toJson(),
    };
  }
}
