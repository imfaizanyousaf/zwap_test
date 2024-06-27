class Messages {
  int id;
  int senderId;
  int receiverId;
  String body;
  DateTime sentAt;

  Messages(
      {required this.id,
      required this.senderId,
      required this.receiverId,
      required this.body,
      required this.sentAt});

  Map<String, dynamic> toJson() => {
        'id': id,
        'senderId': senderId,
        'receiverId': receiverId,
        'body': body,
        'sentAt': sentAt.toIso8601String(),
      };

  factory Messages.fromJson(Map<String, dynamic> json) => Messages(
        id: json['id'] as int,
        senderId: json['senderId'] as int,
        receiverId: json['receiverId'] as int,
        body: json['body'] as String,
        sentAt: DateTime.parse(json['sentAt'] as String),
      );
}
