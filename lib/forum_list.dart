import 'package:flutter/material.dart';
import 'package:lotus/article_list.dart';
import 'package:lotus/colors.dart';

class ForumList extends StatefulWidget {
  const ForumList({super.key});

  @override
  State<ForumList> createState() => _ForumListState();
}

class _ForumListState extends State<ForumList> {
  var questionList=["Soru1","Soru2","Soru3","Soru4","Soru5","Soru6","Soru7"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainPink,
        scrolledUnderElevation: 0.0,
      ),
      body:  Column(
          children: <Widget>[
            _searchBar(context),
            Expanded(
            child: _buildHorizontalListView(context,resim: "resimler/lotus_resim.png", items: questionList)
            ),
          ],
        ),
    );
  }
}

Widget _buildHorizontalListView(BuildContext context,{ required String resim, required List<String> items}) {
  return ListView.builder(
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
    );
}
Widget _searchBar(BuildContext context){
  return Container(
    color: mainPink,
    padding: const EdgeInsets.only(bottom: 8.0,left: 8.0,right: 8.0),
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