import 'package:flutter/material.dart';
import 'package:lotus/colors.dart';
import 'package:lotus/entity/message_entity.dart';
import 'package:lotus/service/chat_service.dart';
import 'package:lotus/service/user_service.dart';
import 'chat_page.dart';


class ConversationsPage extends StatefulWidget {
  final String userId;

  const ConversationsPage({required this.userId});

  @override
  _ConversationsPageState createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  final ChatService chatService = ChatService(baseUrl: 'https://lotusproject.azurewebsites.net/api/');
  final UserService userService = UserService(baseUrl: 'https://lotusproject.azurewebsites.net/api/');
  late Future<List<Conversation>> conversations;
  Map<String, Map<String, String>> userNamesAndImages = {};

  @override
  void initState() {
    super.initState();
    conversations = chatService.getUserConversations(widget.userId);
  }

  Future<void> fetchUserDetails(String userId) async {
    try {
      final userDetails = await userService.getUserById(userId);
      userNamesAndImages[userId] = {
        'name': '${userDetails['userName']} ${userDetails['surname']}',
        'image': userDetails['image'] ??'null',
      };
    } catch (e) {
      print('Kullanıcı bilgileri alınamadı: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainPink,
        title: const Text('Sohbetler'),
      ),
      body: FutureBuilder<List<Conversation>>(
        future: conversations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Henüz sohbet yok'));
          } else {
            final conversations = snapshot.data!;
            return ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                final otherUserId = conversation.messages[0].recipientId;

                return FutureBuilder<void>(
                  future: fetchUserDetails(otherUserId),
                  builder: (context, userDetailsSnapshot) {
                    if (userDetailsSnapshot.connectionState == ConnectionState.waiting) {
                      return const ListTile(
                        leading: CircleAvatar(child: CircularProgressIndicator()),
                        title: Text('Yükleniyor...'),
                      );
                    } else if (userDetailsSnapshot.hasError) {
                      return const ListTile(
                        leading: CircleAvatar(child: Icon(Icons.error)),
                        title: Text('Kullanıcı adı alınamadı'),
                      );
                    } else {
                      final userDetail = userNamesAndImages[otherUserId];
                      final userName = userDetail?['name'] ?? 'Bilinmeyen kullanıcı';
                      final userImage = userDetail?['image']?? 'null';

                      return Column(
                        children: [
                          SizedBox(height: 5.0),
                          ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: userImage != 'null'
                                  ? NetworkImage(userImage)
                                  : null,
                              child: userImage == 'null'
                                  ? Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.grey[700],
                              )
                                  : null,
                            ),
                            title: Text(userName),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                    userId: widget.userId,
                                    otherUserId: otherUserId,
                                  ),
                                ),
                              );
                            },
                          ),
                          const Divider(),
                        ],
                      );
                    }
                  },
                );

              },
            );
          }
        },
      ),
    );
  }
}
