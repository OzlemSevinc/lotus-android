import 'package:flutter/material.dart';
import 'package:lotus/colors.dart';
import 'package:lotus/entity/forum_entity.dart';
import 'package:lotus/question_page.dart';

import 'add_question.dart';
import 'service/forum_service.dart';

class ForumList extends StatefulWidget {
  const ForumList({super.key});

  @override
  State<ForumList> createState() => _ForumListState();
}

class _ForumListState extends State<ForumList> {
  List<Question> questions = [];
  List<ForumQuestionCategory> categories = [];
  final ForumService forumService = ForumService(baseUrl: 'https://lotusproject.azurewebsites.net/api/');
  bool isLoading = true;

  String? searchQuery;
  int? selectedCategoryId;
  bool? sortByAlphabetical;
  bool? sortByAlphabeticalDescending;
  bool? sortByDate;
  bool? sortByDateAscending;
  int? pageNumber ;
  int? pageSize =100;

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchQuestions();
  }

  Future<void> fetchCategories() async {
    try {
      final fetchedCategories = await forumService.fetchQuestionCategories();
      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kategoriler yüklenemedi: $e')),
      );
    }
  }

  Future<void> fetchQuestions() async {
    setState(() {
      isLoading = true;
    });

    try {
      final fetchedQuestions = await forumService.fetchAndFilterQuestions(
        categoryId: selectedCategoryId,
        sortByAlphabetical: sortByAlphabetical,
        sortByAlphabeticalDescending: sortByAlphabeticalDescending,
        sortByDate: sortByDate,
        sortByDateAscending: sortByDateAscending,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      setState(() {
        questions = fetchedQuestions;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sorular yüklenemedi: $e')),
      );
    }
  }

  Future<void> searchQuestions() async {
    setState(() {
      isLoading = true;
    });

    try {
      final searchedQuestions = await forumService.searchQuestions(searchQuery ?? '');
      setState(() {
        questions = searchedQuestions;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
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
                            fetchQuestions();
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
                            fetchQuestions();
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
              : Expanded(
            child: _buildHorizontalListView(
                context, items: questions),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() async{
          final result = await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AddQuestionPage()));
          if (result == true) {
            fetchQuestions();
          }
        },
        backgroundColor: green,
        child: const Icon(Icons.add),
      ),
    );
  }


  Widget _buildHorizontalListView(BuildContext context,
      {  required List<Question> items}) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final question = items[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => QuestionPage(question: question),
                ),
              );
            },
            child: Card(
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              question.question,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text("Sorulma Tarihi: ${question.creationDate}", style: const TextStyle(fontSize: 16)),
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
                searchQuestions();
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
          ElevatedButton.icon(
            onPressed: () => showFilterDialog(context),
            icon: Icon(Icons.filter_list),
            label: Text("Filtrele"),
            style: ElevatedButton.styleFrom(
              primary: mainPink,
              onPrimary: Colors.white,
              minimumSize: Size(150, 48),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => showSortDialog(context),
            icon: Icon(Icons.sort),
            label: Text("Sırala"),
            style: ElevatedButton.styleFrom(
              primary: mainPink,
              onPrimary: Colors.white,
              minimumSize: Size(150, 48),
            ),
          ),
        ],
      ),
    );
  }
}