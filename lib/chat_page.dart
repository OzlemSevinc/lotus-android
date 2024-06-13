import 'package:flutter/material.dart';
import 'package:lotus/entity/message_entity.dart';
import 'package:lotus/entity/user_entity.dart';
import 'package:lotus/service/chat_service.dart';
import 'package:lotus/service/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  final String userId;
  final String otherUserId;

  const ChatPage({required this.userId, required this.otherUserId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatService chatService = ChatService(baseUrl: 'https://lotusproject.azurewebsites.net/api/');
  final UserService userService = UserService(baseUrl: 'https://lotusproject.azurewebsites.net/api/');
  final TextEditingController chatController = TextEditingController();
  late Future<Conversation> conversation;
  bool isLoading = true;
  late User currentUser;
  late User otherUser;
  Map<String, String> userNames = {};

  @override
  void initState() {
    super.initState();
    fetchUserNames();
    conversation = chatService.getConversation(widget.userId, widget.otherUserId);
  }


  Future<void> fetchUserNames() async {
        try {
          final userDetails = await userService.getUserById(widget.userId);
          userNames[widget.userId] = '${userDetails['userName']} ${userDetails['surname']}';
          final otherUserDetails = await userService.getUserById(widget.otherUserId);
          userNames[widget.otherUserId] = '${otherUserDetails['userName']} ${otherUserDetails['surname']}';
          setState(() {});
        } catch (e) {
          print('Kullanıcı bilgileri alınamadı: $e');
        }

    }

  void sendMessage() async {
    try {
      if (chatController.text.isNotEmpty) {
        await chatService.sendMessage(
            widget.userId, widget.otherUserId, chatController.text);
        setState(() {
          conversation =
              chatService.getConversation(widget.userId, widget.otherUserId);
        });
        chatController.clear();
      }
    }catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mesaj gönderilemedi')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userNames[widget.otherUserId]??'Kullanıcı'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<Conversation>(
              future: conversation,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.messages.isEmpty) {
                  return Center(child: Text('Henüz mesaj bulunmamaktadır'));
                }else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }  else {
                  final messages = snapshot.data!.messages;
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return ListTile(
                        title: Text(message.text),
                        subtitle: Text(message.senderId == widget.userId ? userNames[widget.userId] ??'Siz' : userNames[widget.otherUserId]??'Diğer Kullanıcı'),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: chatController,
                    decoration: InputDecoration(hintText: 'Mesaj yazınız'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
