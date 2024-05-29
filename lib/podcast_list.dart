import 'package:flutter/material.dart';
import 'package:lotus/entity/podcast_entity.dart';
import 'package:lotus/podcast_page.dart';
import 'colors.dart';

class PodcastList extends StatefulWidget {
  const PodcastList({super.key});

  @override
  State<PodcastList> createState() => _PodcastListState();
}

class _PodcastListState extends State<PodcastList> {
  var podcastList=[Podcast(id: 4, title: "Moonlight", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas malesuada, purus aliquam hendrerit mollis, ipsum diam posuere erat, egestas venenatis sapien ipsum nec turpis. In vestibulum ex elit, vitae ultrices turpis dignissim in. Vestibulum sed lacus scelerisque, pulvinar purus quis, accumsan lacus.", url: "https://lotuspodcast.blob.core.windows.net/podcast/scott-buckley-moonlight%28chosic.com%29.mp3", image: "resimler/lotus_resim.png"),
    Podcast(id: 55, title: "Bebek Bakımı Nasıl Olur?", description: "description", url: "url", image: "image"),
    Podcast(id: 55, title: "Bebek Bakımı Nasıl Olur?", description: "description", url: "url", image: "image"),
    Podcast(id: 55, title: "Bebek Bakımı Nasıl Olur?", description: "description", url: "url", image: "image"),
    Podcast(id: 55, title: "Bebek Bakımı Nasıl Olur?", description: "description", url: "url", image: "image")];
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
              child:_buildHorizontalListView(context,resim: "resimler/lotus_resim.png", items: podcastList)
          ),
        ],
      ),
    );
  }
}
Widget _buildHorizontalListView(BuildContext context,{ required String resim, required List<Podcast> items}) {
  return  ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final podcast = items[index];
        return GestureDetector(
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context)=>PodcastPage(podcast:podcast),
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
                          Text(podcast.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(podcast.description,style: TextStyle(fontSize: 16), maxLines: 3, overflow: TextOverflow.ellipsis)
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
