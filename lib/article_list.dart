import 'package:flutter/material.dart';
import 'package:lotus/colors.dart';
class ArticleList extends StatefulWidget {
  const ArticleList({super.key});

  @override
  State<ArticleList> createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {
  var articleList=["Makale1","Makale2","Makale3","Makale4","Makale5","Makale6","Makale7"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainPink,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _searchBar(context),
            _buildHorizontalListView(context,resim: "resimler/lotus_resim.png", items: articleList)
          ],
        ),
      ),
    );
  }
}

Widget _buildHorizontalListView(BuildContext context,{ required String resim, required List<String> items}) {
  return SizedBox(
    height: MediaQuery.of(context).size.height,
    child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              child: Row(
                children: [
                  SizedBox(width:150,height:150,child: Image.asset(resim),),
                  Text(items[index]),
                ],
              )
          );
        }
    ),
  );
}

void setState(String item,SearchController controller) {
  controller.closeView(item);
}
Widget _searchBar(BuildContext context){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SearchAnchor(
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            controller: controller,
            padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0)),
            onTap: () {
              controller.openView();
            },
            onChanged: (_) {
              controller.openView();
            },
            leading: const Icon(Icons.search),
          );
        }, suggestionsBuilder:
        (BuildContext context, SearchController controller) {
      return List<ListTile>.generate(5, (int index) {
        final String item = 'item $index';
        return ListTile(
          title: Text(item),
          onTap: () {
            setState(item,controller);
          },
        );
      });
    }),
  );
}

