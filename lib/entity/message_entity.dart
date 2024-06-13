class Message {
  final int messageId;
  final String senderId;
  final String recipientId;
  final String text;

  Message({required this.messageId,required this.senderId, required this.recipientId, required this.text});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageId: json['id'],
      senderId: json['senderId'],
      recipientId: json['recipientId'],
      text: json['text'],
    );
  }
}

class Conversation {
  final String id;
  final List<Message> messages;

  Conversation({required this.id, required this.messages});

  factory Conversation.fromJson(Map<String, dynamic> json) {
    var messagesList = json['messages'] as List;
    List<Message> messageList = messagesList.map((i) => Message.fromJson(i)).toList();

    return Conversation(
      id: json['id'].toString(),
      messages: messageList,
    );
  }
}
