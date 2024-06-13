import 'dart:convert';
import 'package:http/http.dart' as http;

import '../entity/message_entity.dart';

class ChatService {
  final String baseUrl;

  ChatService({required this.baseUrl});

  Future<List<Conversation>> getUserConversations(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/messages/conversations/$userId'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((conversation) => Conversation.fromJson(conversation)).toList();
    } else {
      throw Exception('Sohbetler yüklenemedi');
    }
  }

  Future<Conversation> getConversation(String participant1Id, String participant2Id) async {
    final response = await http.get(Uri.parse('$baseUrl/messages/conversations?participant1Id=$participant1Id&participant2Id=$participant2Id'));
    if (response.statusCode == 200) {
      return Conversation.fromJson(json.decode(response.body)[0]);
    } else {
      throw Exception('Sohbet yüklenemedi');
    }
  }

  Future<void> sendMessage(String senderId, String recipientId, String text) async {
    final response = await http.post(
      Uri.parse('$baseUrl/messages/user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'senderId': senderId,
        'recipientId': recipientId,
        'text': text,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Mesaj gönderilemedi');
    }
  }
}
