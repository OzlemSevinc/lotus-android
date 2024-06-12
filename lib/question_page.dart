import 'package:flutter/material.dart';
import 'package:lotus/colors.dart';
import 'package:lotus/entity/forum_entity.dart';
import 'package:lotus/service/forum_service.dart';
import 'package:lotus/service/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'entity/user_entity.dart';


class QuestionPage extends StatefulWidget {
  final Question question;

  const QuestionPage({super.key, required this.question});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  final answerController = TextEditingController();
  late User currentUser;
  final UserService userService = UserService(baseUrl: 'https://lotusproject.azurewebsites.net/api/');
  final ForumService forumService = ForumService(baseUrl: 'https://lotusproject.azurewebsites.net/api/');
  bool isLoading = true;
  Map<String, String> userNames = {};

  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
    fetchUserNames();
  }

  Future<void> fetchCurrentUser() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final userId = prefs.getString('userId');


      if (userId != null ) {
        final userDetails = await userService.getUserById(userId);
        setState(() {
          currentUser = User(
              name: userDetails['userName'],
              surname: userDetails['surname'],
              email: userDetails['email'],
              pregnancyStatus: userDetails['pregnancyStatus']?.toString(),
              userId: userDetails['id'],
              fetusPicture: userDetails['fetusPicture'],
              userType: userDetails['userType'],
              userImage: userDetails['image']
          );
          isLoading = false;
        });
      }else{
        setState(() {
          isLoading=false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading=false;
      });
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kullanıcı bilgileri alınamadı: $e')),
      );
    }
  }

  Future<void> fetchUserNames() async {
    for (var answer in widget.question.answers) {
      if (!userNames.containsKey(answer.userId)) {
        try {
          final userDetails = await userService.getUserById(answer.userId);
          userNames[answer.userId] = '${userDetails['userName']} ${userDetails['surname']}';
        } catch (e) {
          print('Kullanıcı bilgileri alınamadı: $e');
        }
      }
    }
    setState(() {});
  }

  Future<void> addAnswer() async {
    final answer = Answer(
      id: 0,
      questionId: widget.question.id,
      userId: currentUser.userId!,
      answerContent: answerController.text,
      userType: currentUser.userType!,
    );

    await forumService.addAnswer(answer);
    setState(() {
      widget.question.answers.add(answer);
      answerController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userAnswers = widget.question.answers.where((a) => a.userType == 0).toList();
    final expertAnswers = widget.question.answers.where((a) => a.userType == 1).toList();

    String getUserName(String userId, bool isAnonymous) {
      if (isAnonymous&&widget.question.userId==userId) return 'Anonim';
      return userNames[userId] ?? 'Yükleniyor...';
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainPink,
        title: Text(widget.question.question),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: greenQ,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.question.anonymous == 1
                        ? 'Anonim'
                        : getUserName(widget.question.userId, widget.question.anonymous == 1),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    widget.question.question,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView(
                children: [
                  if (expertAnswers.isNotEmpty) ...[
                    Text(
                      'Uzmanından Cevaplar',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ...expertAnswers.map((a) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: greenA,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getUserName(a.userId, widget.question.anonymous == 1),
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8.0),
                            Text(a.answerContent),
                          ],
                        ),
                      ),
                    )),
                  ],
                  if (userAnswers.isNotEmpty) ...[
                    Text(
                      'Annelerden Cevaplar',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ...userAnswers.map((a) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: greenA,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getUserName(a.userId, widget.question.anonymous == 1),
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8.0),
                            Text(a.answerContent),
                          ],
                        ),
                      ),
                    )),
                  ],
                ],
              ),
            ),
            TextField(
              controller: answerController,
              decoration: InputDecoration(labelText: 'Cevabınızı yazın'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: addAnswer,
              child: Text('Gönder'),
            ),
          ],
        ),
      ),
    );
  }
}
