import 'package:flutter/material.dart';
import 'package:lotus/colors.dart';
import 'package:lotus/entity/article_entity.dart';
import 'package:lotus/podcast_page.dart';
import 'package:lotus/service/article_service.dart';
import 'package:lotus/service/doctor_service.dart';
import 'package:lotus/service/podcast_service.dart';
import 'package:lotus/service/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'article_list.dart';
import 'article_page.dart';
import 'doctor_list.dart';
import 'doctor_page.dart';
import 'entity/doctor_entity.dart';
import 'entity/podcast_entity.dart';
import 'entity/user_entity.dart';
import 'podcast_list.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late User currentUser ;
  List<Article> articles = [];
  List<Podcast> podcasts = [];
  List<Doctor> doctors=[];
  //var articleList=["Makale1","Makale2","Makale3","Makale4","Makale5","Makale6","Makale7"];
  //var podcastList=["Podcast1","Podcast2","Podcast3","Podcast4","Podcast5","Podcast6","Podcast7"];
 // var doctorList=["Doktor1","Doktor2","Doktor3","Doktor4","Doktor5","Doktor6","Doktor7"];
  final UserService userService = UserService(baseUrl: 'https://lotusproject.azurewebsites.net/api/');
  final ArticleService articleService = ArticleService(baseUrl: 'https://lotusproject.azurewebsites.net/api/');
  final PodcastService podcastService = PodcastService(baseUrl: 'https://lotusproject.azurewebsites.net/api/');
  final DoctorService doctorService = DoctorService(baseUrl: 'https://lotusproject.azurewebsites.net/api/');
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
    fetchArticles();
    fetchPodcasts();
    fetchDoctors();
  }

  Future<void> fetchCurrentUser() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final userId = prefs.getString('userId');


      if (userId != null ) {
        final userDetails = await userService.getUserById(userId);
        if (mounted) {
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
        }
      }else{
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kullanıcı bilgileri alınamadı: $e')),
      );
    }
  }

  Future<void> fetchArticles() async {
    try {
      final fetchedArticles = await articleService.fetchandFilterArticles(pageNumber: 0, pageSize: 5);
      if (mounted) {
        setState(() {
          articles = fetchedArticles;
        });
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Makaleler yüklenemedi: $e')),
      );
    }
  }
  Future<void> fetchPodcasts() async {
    try {
      final fetchedPodcasts = await podcastService.fetchandFilterPodcasts(pageNumber: 0,pageSize: 5);
      if (mounted) {
        setState(() {
          podcasts = fetchedPodcasts;
        });
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Podcastler yüklenemedi: $e')),
      );
    }
  }

  Future<void> fetchDoctors() async {
    try {
      final fetchedDoctors = await doctorService.fetchAndFilterDoctors(pageNumber: 0,pageSize: 5);
      if (mounted) {
        setState(() {
          doctors = fetchedDoctors;
        });
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Doktorlar yüklenemedi: $e')),
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
                  borderRadius: BorderRadius.circular(20),
                  child: currentUser.fetusPicture != null && currentUser.fetusPicture!.isNotEmpty
                      ? Image.network(currentUser.fetusPicture!, fit: BoxFit.cover)
                      : Image.asset('resimler/lotus_resim.png', fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height:20,),
                _buildTextandTextButton(context,title: "Makale",textButton: "Tümünü Gör",destination: (context) => const ArticleList()),
                _buildHorizontalListView<Article>(articles),
                _buildTextandTextButton(context,title: "Podcast",textButton: "Tümünü Gör",destination: (context) => const PodcastList()),
                _buildHorizontalListView<Podcast>(podcasts),
                _buildTextandTextButton(context,title: "Doktorlar",textButton: "Tümünü Gör",destination: (context) => const DoctorList()),
                _buildHorizontalListView<Doctor>(doctors),
            ],
          ),
        ),
      ),
    );
  }


Widget _buildHorizontalListView<T>(List<T>items) {
  return SizedBox(
    height: 220,
    child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];
          return GestureDetector(
            onTap: (){
              if (item is Article){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ArticlePage(article: item),
                  ),
                );
              }else if (item is Podcast) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PodcastPage(podcast: item),
                  ),
                );
              }else if (item is Doctor){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DoctorPage(doctor: item),
                  ),
                );
              }
            },
            child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 150,height: 150,
                      child:  item is Article && item.image != null && item.image.isNotEmpty
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(item.image, fit: BoxFit.cover),
                      )
                          : item is Podcast && item.image != null && item.image.isNotEmpty
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(item.image, fit: BoxFit.cover),
                      )
                          : item is Doctor && item.image != null && item.image.isNotEmpty
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(item.image, fit: BoxFit.cover),
                      )
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset('resimler/lotus_resim.png', fit: BoxFit.cover),
                      ),
                    ),
                    Container(
                      width: 150,
                        padding: const EdgeInsets.all(8.0),
                        child: Text(item is Article ? item.title :item is Podcast ? item.title :item is Doctor ? '${item.name} ${item.surname}': 'Başlık Yok',style :TextStyle(fontSize: 14),maxLines: 2,overflow: TextOverflow.ellipsis)),
                  ],
                )
            ),
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