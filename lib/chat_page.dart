import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lotus/entity/message_entity.dart';
import 'package:lotus/entity/user_entity.dart';
import 'package:lotus/service/chat_service.dart';
import 'package:lotus/service/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lotus/colors.dart';

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
  bool isDoctor=false;
  Map<String, String> userNames = {};
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    fetchUserNames();
    getCurrentUserId();
    fetchRecipientDetails();
    conversation = chatService.getConversation(widget.userId, widget.otherUserId);
  }

  Future<void> getCurrentUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getString('userId');
    });
  }

  Future<void> fetchRecipientDetails() async {
    try {
      final userDetails = await userService.getUserById(widget.otherUserId);
      setState(() {
        final userType = userDetails['userType'];

        if(userType==0){
          isDoctor=false;
        }else{
          isDoctor=true;
        }
      });

    } catch (e) {
      print('Satıcı bilgileri alınamadı: $e');
    }
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
            widget.userId, widget.otherUserId, chatController.text,isDoctor: isDoctor);
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
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mesaj gönderilemedi: $e')),
      );
    }
  }

  Future<void> deleteMessage(int messageId) async {
    try {
      await chatService.deleteMessage(messageId);
      setState(() {
        conversation = chatService.getConversation(widget.userId, widget.otherUserId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mesaj başarıyla silindi')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mesaj silinemedi: $e')),
      );
    }
  }


  void showDeleteConfirmationDialog(int messageId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Mesajı silmek istiyor musunuz?'),
          actions: <Widget>[
            TextButton(
              child: const Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Sil'),
              style: ElevatedButton.styleFrom(backgroundColor: deleteRed),
              onPressed: () {
                Navigator.of(context).pop();
                deleteMessage(messageId);
              },
            ),
          ],
        );
      },
    );
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
                      final timestamp = message.timestamp;
                      final DateTime parsedTimestamp = DateTime.parse(timestamp);
                      final String formattedTime = DateFormat('HH:mm').format(parsedTimestamp);
                      return GestureDetector(
                        onLongPress: () {
                          if (message.senderId == widget.userId) {
                            showDeleteConfirmationDialog(message.messageId);
                          }
                        },
                        child: Align(
                          alignment: message.senderId==currentUserId ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: message.senderId==currentUserId  ? chatOwner : chatOther,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.senderId == widget.userId
                                      ? userNames[widget.userId] ?? 'Siz'
                                      : userNames[widget.otherUserId] ?? 'Diğer Kullanıcı',
                                  style: TextStyle(fontSize: 12.0, color: message.senderId==currentUserId  ? Colors.white70 : Colors.black54),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  message.text,
                                  style: TextStyle(color: message.senderId==currentUserId  ? chatOwnerText : chatOtherText),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  formattedTime,
                                  style: TextStyle(fontSize: 12.0, color: message.senderId==currentUserId  ? Colors.white70 : Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ),
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
