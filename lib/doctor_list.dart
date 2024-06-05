import 'package:flutter/material.dart';
import 'colors.dart';

class DoctorList extends StatefulWidget {
  const DoctorList({super.key});

  @override
  State<DoctorList> createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  var doctorList = [
    "Doktor1",
    "Doktor2",
    "Doktor3",
    "Doktor4",
    "Doktor5",
    "Doktor6",
    "Doktor7"
  ];

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
          Expanded(
              child: _buildHorizontalListView(
                  context, resim: "resimler/lotus_resim.png", items: doctorList)
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalListView(BuildContext context,
      { required String resim, required List<String> items}) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final doctor = items[index];
          return Card(
              child: Row(
                children: [
                  SizedBox(width: 150, height: 150, child: Image.asset(resim),),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(doctor, style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              )
          );
        }
    );
  }

  void addItemToSearchHistory(String item) {
    setState(() {

    });
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
              addItemToSearchHistory(item);
            },
          );
        });
      }),
    );
  }
}