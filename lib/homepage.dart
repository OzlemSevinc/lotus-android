import 'package:flutter/material.dart';
import 'package:lotus/article_list.dart';
import 'package:lotus/colors.dart';
import 'package:lotus/doctor_list.dart';
import 'package:lotus/podcast_list.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String userName="Jane";
  String selectedWeek="0";
  var articleList=["Makale1","Makale2","Makale3","Makale4","Makale5","Makale6","Makale7"];
  var podcastList=["Podcast1","Podcast2","Podcast3","Podcast4","Podcast5","Podcast6","Podcast7"];
  var doctorList=["Doktor1","Doktor2","Doktor3","Doktor4","Doktor5","Doktor6","Doktor7"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [mainPink,powderWhite],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 50,),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 20),
                child: Text(
                  "Merhaba, $userName",
                  style: const TextStyle(
                    fontSize: 30,
                    fontFamily: 'Roboto Mono',
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 10),
                child: Text(
                  "Bebeğiniz şu anda $selectedWeek haftalık yaklaşık "
                      "olarak bu şekilde görünüyor",

                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Roboto Mono',
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              SizedBox(width:300,height:300,
                  child: Image.asset("resimler/lotus_resim.png")),
              const SizedBox(height:20,),
              _buildTextandTextButton(context,title: "Makale",textButton: "Tümünü Gör",destination: (context) => const ArticleList()),
              _buildHorizontalListView(resim:"resimler/lotus_resim.png",items: articleList),
              _buildTextandTextButton(context,title: "Podcast",textButton: "Tümünü Gör",destination: (context) => const PodcastList()),
              _buildHorizontalListView(resim:"resimler/lotus_resim.png",items: podcastList),
              _buildTextandTextButton(context,title: "Doktorlar",textButton: "Tümünü Gör",destination: (context) => const DoctorList()),
              _buildHorizontalListView(resim:"resimler/lotus_resim.png",items: doctorList),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildHorizontalListView({ required String resim, required List<String> items}) {
  return SizedBox(
    height: 200,
    child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              child: Column(
                children: [
                  SizedBox(width: 150,height: 150,child: Image.asset(resim),),
                  Text(items[index]),
                ],
              )
          );
        }
    ),
  );
}

Widget _buildTextandTextButton(BuildContext context,{required String title, required String textButton,required WidgetBuilder destination}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          title,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      Spacer(),
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: TextButton(onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: destination),
          );
        },
            child: Text(textButton, textAlign: TextAlign.right,
              style: TextStyle(fontSize:16,color: coal,decoration: TextDecoration.underline),)),
      )
    ],
  );
}