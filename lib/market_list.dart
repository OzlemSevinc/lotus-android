import 'package:flutter/material.dart';
import 'package:lotus/colors.dart';

import 'article_list.dart';
class MarketList extends StatefulWidget {
  const MarketList({super.key});

  @override
  State<MarketList> createState() => _MarketListState();
}

class _MarketListState extends State<MarketList> {
  var productList=["Ürün1","Ürün2","Ürün3","Ürün4","Ürün5","Ürün6","Ürün7","Ürün8"];
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
            _buildHorizontalListView(context,resim: "resimler/lotus_resim.png", items: productList)
          ],
        ),
      ),
    );
  }
}
Widget _buildHorizontalListView(BuildContext context,{ required String resim, required List<String> items}) {
  return SizedBox(
    height: MediaQuery.of(context).size.height*0.93,
    child:ListView.builder(
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
