import 'package:flutter/material.dart';
import 'package:lotus/colors.dart';
import 'package:lotus/entity/forum_entity.dart';
import 'package:lotus/service/forum_service.dart';
import 'package:lotus/service/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'entity/user_entity.dart';


class AddQuestionPage extends StatefulWidget {

  const AddQuestionPage({super.key});

  @override
  State<AddQuestionPage> createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  final questionController = TextEditingController();
  int? selectedCategoryId;
  bool isAnonymous = false;
  bool isLoading = false;
  late User currentUser;
  List<ForumQuestionCategory> categories = [];
  final UserService userService = UserService(baseUrl: 'https://lotusproject.azurewebsites.net/api/');
  final ForumService forumService = ForumService(baseUrl: 'https://lotusproject.azurewebsites.net/api');

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchCurrentUser();
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
  Future<void> fetchCategories() async {
    setState(() {
      isLoading = true;
    });
    try {
      final fetchedCategories = await forumService.fetchQuestionCategories();
      setState(() {
        categories = fetchedCategories;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kategoriler yüklenemedi: $e')),
      );
    }
  }

  Future<void> addQuestion() async {
    if (selectedCategoryId == null || questionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen tüm alanları doldurun')),
      );
      return;
    }

    final question = Question(
      id: 0,
      userId: currentUser.userId,
      userType: currentUser.userType,
      forumQuestionCategoryId: selectedCategoryId!,
      question: questionController.text,
      creationDate: DateTime.now().toIso8601String(),
      anonymous: isAnonymous ? 1 : 0,
      answers: [],
    );

    try {
      setState(() {
        isLoading = true;
      });
      await forumService.addQuestion(question);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Soru başarıyla eklendi')),
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Soru eklenemedi: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainPink,
        title: Text('Soru Ekle'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: questionController,
              decoration: InputDecoration(labelText: 'Soru'),
            ),
            DropdownButton<int>(
              hint: Text("Kategori seçiniz"),
              value: selectedCategoryId,
              onChanged: (int? value) {
                setState(() {
                  selectedCategoryId = value;
                });
              },
              items: categories.map((category) {
                return DropdownMenuItem(
                  child: Text(category.name),
                  value: category.id,
                );
              }).toList(),
            ),
            CheckboxListTile(
              title: Text('Anonim'),
              value: isAnonymous,
              onChanged: (bool? value) {
                setState(() {
                  isAnonymous = value ?? false;
                });
              },
            ),
            ElevatedButton(
              onPressed: isLoading ? null : addQuestion,
              child: Text('Ekle'),
            ),
          ],
        ),
      ),
    );
  }
}
