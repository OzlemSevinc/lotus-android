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
  int? pageSize=100;
  List<ArticleCategory> categories=[];
  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchandFilterArticles();
  }

  Future<void> fetchCategories() async {
    try {
      final fetchedCategories = await articleService.fetchArticleCategories();
      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kategoriler yüklenemedi: $e')),
      );
    }
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

  void showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              height: MediaQuery.of(context).size.height * 0.4,
              child: Wrap(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                        isExpanded: true,
                      ),
                      SizedBox(height: 32.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            fetchandFilterArticles();
                          },
                          child: Text("Uygula"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void showSortDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text("Alfabetik Sırala (A-Z)"),
                        leading: Radio<bool>(
                          value: true,
                          groupValue: sortByAlphabetical,
                          onChanged: (bool? value) {
                            setState(() {
                              sortByAlphabetical = value;
                              sortByAlphabeticalDescending = false;
                              sortByDate = false;
                              sortByDateAscending = false;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: Text("Alfabetik Sırala (Z-A)"),
                        leading: Radio<bool>(
                          value: true,
                          groupValue: sortByAlphabeticalDescending,
                          onChanged: (bool? value) {
                            setState(() {
                              sortByAlphabetical = false;
                              sortByAlphabeticalDescending = value;
                              sortByDate = false;
                              sortByDateAscending = false;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: Text("Tarihe Göre Sırala (Yeni)"),
                        leading: Radio<bool>(
                          value: true,
                          groupValue: sortByDate,
                          onChanged: (bool? value) {
                            setState(() {
                              sortByAlphabetical = false;
                              sortByAlphabeticalDescending = false;
                              sortByDate = value;
                              sortByDateAscending = false;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: Text("Tarihe Göre Sırala (Eski)"),
                        leading: Radio<bool>(
                          value: true,
                          groupValue: sortByDateAscending,
                          onChanged: (bool? value) {
                            setState(() {
                              sortByAlphabetical = false;
                              sortByAlphabeticalDescending = false;
                              sortByDate = false;
                              sortByDateAscending = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 16.0),
                      SizedBox(
                        width: 400,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            fetchandFilterArticles();
                          },
                          child: Text("Uygula"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
          filterAndSortButtons(),
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

  Widget filterAndSortButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: ElevatedButton.icon(
              onPressed: () => showFilterDialog(context),
              icon: Icon(Icons.filter_list),
              label: Text("Filtrele"),
              style: ElevatedButton.styleFrom(
                primary: mainPink,
                onPrimary: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: ElevatedButton.icon(
              onPressed: () => showSortDialog(context),
              icon: Icon(Icons.sort),
              label: Text("Sırala"),
              style: ElevatedButton.styleFrom(
                primary: mainPink,
                onPrimary: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
