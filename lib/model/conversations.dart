import 'package:zwap_test/model/messages.dart';

class Conversations {
  final int id;
  final int userAId;
  final int userBId;
  final List<Messages> messages;

  Conversations({
    required this.id,
    required this.userAId,
    required this.userBId,
    required this.messages,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userAId': userAId,
        'userBId': userBId,
        'messages': messages.map((message) => message.toJson()).toList(),
      };

  factory Conversations.fromJson(Map<String, dynamic> json) => Conversations(
        id: json['id'] as int,
        userAId: json['userAId'] as int,
        userBId: json['userBId'] as int,
        messages: List<Messages>.from(
          json['messages'].map((message) => Messages.fromJson(message))
              as Iterable<dynamic>,
        ),
      );
}
