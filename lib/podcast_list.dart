import 'package:flutter/material.dart';
import 'package:lotus/entity/podcast_entity.dart';
import 'package:lotus/podcast_page.dart';
import 'package:lotus/service/podcast_service.dart';
import 'colors.dart';

class PodcastList extends StatefulWidget {
  const PodcastList({super.key});

  @override
  State<PodcastList> createState() => _PodcastListState();
}

class _PodcastListState extends State<PodcastList> {
  List<Podcast> podcastList = [];
  final PodcastService podcastService = PodcastService(baseUrl: 'https://lotusproject.azurewebsites.net/api');
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
    fetchandFilterPodcast();
  }

  Future<void> fetchandFilterPodcast() async {
    setState(() {
      isLoading = true;
    });

    try {
      final filteredPodcasts = await podcastService.fetchandFilterPodcasts(
        categoryId: selectedCategoryId,
        sortByAlphabetical: sortByAlphabetical,
        sortByAlphabeticalDescending: sortByAlphabeticalDescending,
        sortByDate: sortByDate,
        sortByDateAscending: sortByDateAscending,
        pageNumber: pageNumber ,
        pageSize:pageSize ,
      );
      setState(() {
        podcastList = filteredPodcasts;
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

  Future<void> searchPodcasts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final searchedPodcasts = await podcastService.searchPodcasts(searchQuery ?? '');
      setState(() {
        podcastList = searchedPodcasts;
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
                  items: podcastList)
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalListView(BuildContext context,
      { required String resim, required List<Podcast> items}) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final podcast = items[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PodcastPage(podcast: podcast),
                ),
              );
            },
            child: Card(
                child: Row(
                  children: [
                ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                podcast.image ?? '',
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
                            Text(podcast.title, style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(podcast.description, style: TextStyle(
                                fontSize: 16),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis)
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
                searchPodcasts();
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