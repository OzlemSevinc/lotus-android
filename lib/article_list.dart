import 'package:flutter/material.dart';
import 'package:lotus/article_page.dart';
import 'package:lotus/colors.dart';
import 'package:lotus/service/article_service.dart';

import 'entity/article_entity.dart';

class ArticleList extends StatefulWidget {
  const ArticleList({super.key});

  @override
  State<ArticleList> createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {
  List<Article> articleList = [];
  //Article article = Article(id:0,title: "",content: "",date: "",writer: "",image: "",categoryId: 0);
  final ArticleService articleService = ArticleService(baseUrl: 'https://lotusproject.azurewebsites.net/api');
  bool isLoading = true;

  String? searchQuery;
  int? selectedCategoryId;
  bool? sortByAlphabetical;
  bool? sortByAlphabeticalDescending;
  bool? sortByDate;
  bool? sortByDateAscending;
  int? pageNumber;
  int? pageSize;

  @override
  void initState() {
    super.initState();
    fetchandFilterArticles();
  }

  Future<void> fetchandFilterArticles() async {
    setState(() {
      isLoading = true;
    });

    try {
      final filteredArticles = await articleService.fetchandFilterArticles(
        categoryId: selectedCategoryId,
        sortByAlphabetical: sortByAlphabetical,
        sortByAlphabeticalDescending: sortByAlphabeticalDescending,
        sortByDate: sortByDate,
        sortByDateAscending: sortByDateAscending,
        pageNumber: pageNumber ,
        pageSize:pageSize ,
      );
      setState(() {
        articleList = filteredArticles;
        print(articleList);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Filtreleme başarısız: $e')),
      );
    }
  }

  Future<void> searchArticles() async {
    setState(() {
      isLoading = true;
    });

    try {
      final searchedArticles = await articleService.searchArticles(searchQuery ?? '');
      setState(() {
        articleList = searchedArticles;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Arama başarısız: $e')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainPink,
        scrolledUnderElevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          _searchBar(context),
           isLoading
              ? Center(child: CircularProgressIndicator())
              :Expanded(
              child: _buildHorizontalListView(
                  context, resim: "resimler/lotus_resim.png",
                  items: articleList)
          ),
        ],
      ),
    );
  }


  Widget _buildHorizontalListView(BuildContext context,
      { required String resim, required List<Article> items}) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final article = items[index];
          print(article.title);
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ArticlePage(article: article),
                ),
              );
            },
            child: Card(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        article.image ?? '',
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                        errorBuilder: (context,error,stackTrace){
                          return Image.asset(resim, width: 150,height: 150, fit: BoxFit.cover);
                        },
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article.title,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text("Yazar: ${article.writer}", style: const TextStyle(fontSize: 16)),
                            Text("Yayınlanma Tarihi: ${article.date}", style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
            ),
          );
        }
    );
  }


  Widget _searchBar(BuildContext context) {
    return Container(
      color: mainPink,
      padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
      child: SearchAnchor(
          builder: (BuildContext context, SearchController controller) {
            return SearchBar(
              controller: controller,
              padding: const MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0)),
              onTap: () {
              },
              onChanged: (value) {
                setState(() {
                  searchQuery=value;
                });
              },
              onSubmitted: (value){
                searchArticles();
              },
              leading: const Icon(Icons.search),
            );
          }, suggestionsBuilder:
          (BuildContext context, SearchController controller) {
        return [];
      }),
    );
  }
}
