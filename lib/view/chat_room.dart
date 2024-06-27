import 'package:flutter/material.dart';
import 'package:zwap_test/model/conversations.dart';
import 'package:zwap_test/model/messages.dart';
import 'package:zwap_test/model/user.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/utils/conversation_mannager.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatRoom extends StatefulWidget {
  final User sender;
  final User receiver;
  const ChatRoom({super.key, required this.sender, required this.receiver});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final List<Messages> _messages = [];
  final TextEditingController _controller = TextEditingController();
  int? conversationId = null;

  void _sendMessage() {
    if (_controller.text.isNotEmpty && _controller.text != null) {
      ConversationManager conversationManager = ConversationManager();

      conversationManager.saveConversation(Conversations(
        id: conversationId ?? 1,
        userAId: widget.sender.id,
        userBId: widget.receiver.id,
        messages: _messages,
      ));
      Messages message = Messages(
        id: 1,
        senderId: widget.sender.id,
        receiverId: widget.receiver.id,
        body: _controller.text,
        sentAt: DateTime.now(),
      );
      setState(() {
        _messages.add(message);
        _controller.clear();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    ConversationManager conversationManager = ConversationManager();
    conversationManager
        .getConversation(widget.receiver.id)
        .then((conversation) {
      if (conversation != null) {
        setState(() {
          conversationId = conversation.id;
          _messages.addAll(conversation.messages);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: widget.receiver.logo != null
                  ? NetworkImage(
                      widget.receiver.logo ??
                          'https://avatar.iran.liara.run/username?username=${widget.receiver.firstName}+${widget.receiver.lastName}',
                    )
                  : NetworkImage(
                      'https://avatar.iran.liara.run/username?username=${widget.receiver.firstName}+${widget.receiver.lastName}',
                    ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
                '${widget.receiver.firstName + ' ' + widget.receiver.lastName}'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(16.0),
                  // margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: isCurrentUser ? 60.0 : 10.0, right: isCurrentUser ? 10.0 : 60.0),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment:
                            _messages[index].senderId == widget.sender.id
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                        children: [
                          _messages[index].senderId != widget.sender.id
                              ? Text(
                                  '${widget.sender.firstName + ' ' + widget.sender.lastName}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                )
                              : Container(),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColor.primaryDark,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(_messages[index].body,
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "${_messages[index].sentAt.hour.toString().padLeft(2, '0')}:${_messages[index].sentAt.minute.toString().padLeft(2, '0')}",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundImage: widget.sender.logo != null
                              ? NetworkImage(
                                  widget.sender.logo ??
                                      'https://avatar.iran.liara.run/username?username=${widget.sender.firstName}+${widget.sender.lastName}',
                                )
                              : NetworkImage(
                                  'https://avatar.iran.liara.run/username?username=${widget.sender.firstName}+${widget.sender.lastName}',
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      fillColor: Colors.grey[200],
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      hintText: 'Enter your message here...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
