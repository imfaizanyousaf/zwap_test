import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zwap_test/model/conversations.dart';
import 'package:zwap_test/model/messages.dart';

class ConversationManager {
  static const String _conversationsKey = 'conversations';

  Future<void> saveConversation(Conversations conversation) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedData = jsonEncode(conversation.toJson());
    await prefs.setString(
        _conversationsKey + conversation.id.toString(), encodedData);
  }

  Future<Conversations?> getConversation(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _conversationsKey + userId.toString();
    final encodedData = prefs.getString(key);

    if (encodedData != null) {
      final jsonData = jsonDecode(encodedData);
      return Conversations.fromJson(jsonData);
    } else {
      return null;
    }
  }

  Future<void> removeConversation(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _conversationsKey + userId.toString();
    await prefs.remove(key);
  }
}
