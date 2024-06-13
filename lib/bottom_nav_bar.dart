import 'package:flutter/material.dart';
import 'package:lotus/chat_history_page.dart';
import 'package:lotus/homepage.dart';
import 'package:lotus/forum_list.dart';
import 'package:lotus/market_list.dart';
import 'package:lotus/profile.dart';
import 'package:lotus/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int chosenIndex=0;
  late String currentUserId;

  @override
  void initState() {
    super.initState();
    getCurrentUserId();
  }

  Future<void> getCurrentUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getString('userId')!;
    });
  }
  static List<Widget> pages(String? currentUserId) => [const Homepage(),const ForumList(), ConversationsPage(userId: currentUserId!),const MarketList(),if (currentUserId != null) Profile(userId: currentUserId),];

  Future<bool> onWillPop() async {
    if (chosenIndex != 0) {
      setState(() {
        chosenIndex = 0;
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: Center(
            child: currentUserId != null
                ? pages(currentUserId).elementAt(chosenIndex)
                : const CircularProgressIndicator()),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: mainPink,
          ),
        child :BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home),label:"Anasayfa"),
            BottomNavigationBarItem(icon: Icon(Icons.question_answer),label:"Forum"),
            BottomNavigationBarItem(icon: Icon(Icons.message),label:"Sohbet"),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart),label:"Pazar"),
            BottomNavigationBarItem(icon: Icon(Icons.person),label:"Profil"),
          ],
          currentIndex: chosenIndex,
          backgroundColor: mainPink,
          selectedItemColor: green,
          unselectedItemColor: white,
          onTap: (index){
            setState((){
              chosenIndex=index;
            }
            );
          },
        ),
        ),
      ),
    );
  }
}
