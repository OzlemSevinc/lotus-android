import 'package:flutter/material.dart';
//import 'package:lotus/article_list.dart';
import 'package:lotus/colors.dart';
import 'package:lotus/service/article_service.dart';
import 'package:lotus/service/podcast_service.dart';
//import 'package:lotus/doctor_list.dart';
//import 'package:lotus/podcast_list.dart';
import 'package:lotus/service/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'article_list.dart';
import 'doctor_list.dart';
import 'entity/user_entity.dart';
import 'podcast_list.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  User currentUser=User(name:"null",surname: "null",email:null,pregnancyStatus: null,userId: null,fetusPicture: null);
  List<dynamic> articles = [];
  List<dynamic> podcasts = [];
  //var articleList=["Makale1","Makale2","Makale3","Makale4","Makale5","Makale6","Makale7"];
  //var podcastList=["Podcast1","Podcast2","Podcast3","Podcast4","Podcast5","Podcast6","Podcast7"];
  var doctorList=["Doktor1","Doktor2","Doktor3","Doktor4","Doktor5","Doktor6","Doktor7"];
  final UserService userService = UserService(baseUrl: 'https://lotusproject.azurewebsites.net/api/');
  final ArticleService articleService = ArticleService(baseUrl: 'https://lotusproject.azurewebsites.net/api/');
  final PodcastService podcastService = PodcastService(baseUrl: 'https://lotusproject.azurewebsites.net/api/');
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
    fetchArticles();
    fetchPodcasts();
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
            fetusPicture: userDetails['fetusPicture']
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

  Future<void> fetchArticles() async {
    try {
      final fetchedArticles = await articleService.fetchArticles(pageNumber: 0, pageSize: 5);
      setState(() {
        articles = fetchedArticles;
      });
      print(articles[0]['image']);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Makaleler yüklenemedi: $e')),
      );
    }
  }
  Future<void> fetchPodcasts() async {
    try {
      final fetchedPodcasts = await podcastService.fetchPodcasts();
      setState(() {
        podcasts = fetchedPodcasts;
      });
      print(podcasts[0]);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Podcastler yüklenemedi: $e')),
      );
    }
  }
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
        child: isLoading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 50,),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 20),
                child: Text(
                  "Merhaba, ${currentUser.name}",
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
                  "Bebeğiniz şu anda ${currentUser.pregnancyStatus} haftalık yaklaşık "
                      "olarak bu şekilde görünüyor",

                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Roboto Mono',
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              SizedBox(
                width: 300,
                height: 300,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
                  child: currentUser.fetusPicture != null && currentUser.fetusPicture!.isNotEmpty
                      ? Image.network(currentUser.fetusPicture!, fit: BoxFit.cover)
                      : Image.asset('resimler/lotus_resim.png', fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height:20,),
                _buildTextandTextButton(context,title: "Makale",textButton: "Tümünü Gör",destination: (context) => const ArticleList()),
                _buildHorizontalListView(articles),
                _buildTextandTextButton(context,title: "Podcast",textButton: "Tümünü Gör",destination: (context) => const PodcastList()),
                _buildHorizontalListView(podcasts),
                _buildTextandTextButton(context,title: "Doktorlar",textButton: "Tümünü Gör",destination: (context) => const DoctorList()),
                _buildHorizontalListView(articles),
            ],
          ),
        ),
      ),
    );
  }


Widget _buildHorizontalListView(List<dynamic>items) {
  return SizedBox(
    height: 220,
    child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];
          return Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 150,height: 150,child:  item['image'] != null && item['image'].isNotEmpty
                      ? Image.network(
                    item['image'],
                    fit: BoxFit.cover,
                  )
                      : Image.asset('resimler/lotus_resim.png'),
                  ),
                  Container(
                    width: 150,
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item['title'] ?? 'Başlık Yok',style :TextStyle(fontSize: 14),maxLines: 2,overflow: TextOverflow.ellipsis)),
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
}