import 'package:flutter/material.dart';
import 'package:lotus/article_page.dart';
import 'package:lotus/colors.dart';
import 'entity/article_entity.dart';

class ArticleList extends StatefulWidget {
  const ArticleList({super.key});

  @override
  State<ArticleList> createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {
  List<Article> articleList = [
    Article(title: "Makale1", content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer feugiat diam sed posuere viverra. Phasellus accumsan lacus a nulla luctus hendrerit sit amet quis purus. Vivamus maximus purus vel velit fermentum, eget pretium nisi ultrices. Nullam convallis volutpat lectus. Nullam dapibus tortor aliquet nisi rhoncus, ac tincidunt ex volutpat. Cras efficitur libero et iaculis dictum. Nulla sed ullamcorper ligula, ut vestibulum nisl.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer feugiat diam sed posuere viverra. Phasellus accumsan lacus a nulla luctus hendrerit sit amet quis purus. Vivamus maximus purus vel velit fermentum, eget pretium nisi ultrices. Nullam convallis volutpat lectus. Nullam dapibus tortor aliquet nisi rhoncus, ac tincidunt ex volutpat. Cras efficitur libero et iaculis dictum. Nulla sed ullamcorper ligula, ut vestibulum nisl.", writer: "Yazar1", category: "Kategori1"),
    Article(title: "Makale2", content: "İçerik2", writer: "Yazar2", category: "Kategori2"),
    Article(title: "Makale3", content: "İçerik3", writer: "Yazar3", category: "Kategori3"),
    Article(title: "Makale4", content: "İçerik4", writer: "Yazar4", category: "Kategori4"),
    Article(title: "Makale5", content: "İçerik5", writer: "Yazar5", category: "Kategori5"),
    Article(title: "Makale6", content: "İçerik6", writer: "Yazar6", category: "Kategori6"),
    Article(title: "Makale7", content: "İçerik7", writer: "Yazar7", category: "Kategori7"),
    Article(title: "Makale8", content: "İçerik8", writer: "Yazar8", category: "Kategori8"),
  ];
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
              child:_buildHorizontalListView(context,resim: "resimler/lotus_resim.png", items: articleList)
            ),
          ],
        ),
    );
  }
}

Widget _buildHorizontalListView(BuildContext context,{ required String resim, required List<Article> items}) {
  return  ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final article = items[index];
          return GestureDetector(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=>ArticlePage(article: article),
                ),
              );
            },
            child: Card(
                child: Row(
                  children: [
                    SizedBox(width:150,height:150,child: Image.asset(resim),),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(article.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text("Yazar: ${article.writer}", style: TextStyle(fontSize: 16)),
                            Text("Kategori: ${article.category}", style: TextStyle(fontSize: 16)),
                            Text(article.content, style: TextStyle(fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
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

void setState(String item,SearchController controller) {
  controller.closeView(item);
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

