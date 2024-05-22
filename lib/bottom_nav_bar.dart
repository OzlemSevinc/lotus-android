import 'package:flutter/material.dart';
import 'package:lotus/homepage.dart';
import 'package:lotus/forum_list.dart';
import 'package:lotus/market_list.dart';
import 'package:lotus/profile.dart';
import 'package:lotus/colors.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int chosenIndex=0;
  static List<Widget> pages=<Widget>[const Homepage(),const ForumList(),const MarketList(),const MarketList(),const Profile()];

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
            child: pages.elementAt(chosenIndex)),
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
