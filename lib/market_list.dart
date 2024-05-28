import 'package:flutter/material.dart';
import 'package:lotus/add_product.dart';
import 'package:lotus/colors.dart';
import 'package:lotus/product_page.dart';
import 'article_list.dart';
import 'entity/product_entity.dart';

class MarketList extends StatefulWidget {
  const MarketList({super.key});

  @override
  State<MarketList> createState() => _MarketListState();
}

class _MarketListState extends State<MarketList> {
  List<Product> productList = [
    Product(name: "Ürün1", definition: "Tanım1", ownerId: "Ahmet", price: 10.0, category: "Kategori1"),
    Product(name: "Ürün2", definition: "Tanım2", ownerId: "Ahmet", price: 20.0, category: "Kategori2"),
    Product(name: "Ürün3", definition: "Tanım3", ownerId: "Mehmet", price: 30.0, category: "Kategori3"),
    Product(name: "Ürün4", definition: "Tanım4", ownerId: "Ahmet", price: 40.0, category: "Kategori4"),
    Product(name: "Ürün5", definition: "Tanım5", ownerId: "Ali", price: 50.0, category: "Kategori5"),
    Product(name: "Ürün6", definition: "Tanım6", ownerId: "Veli", price: 60.0, category: "Kategori6"),
    Product(name: "Ürün7", definition: "Tanım7", ownerId: "Ayşe", price: 70.0, category: "Kategori7"),
    Product(name: "Ürün8", definition: "Tanım8", ownerId: "Fatma", price: 80.0, category: "Kategori8"),
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
              child: _buildHorizontalListView(context,resim: "resimler/lotus_resim.png", items: productList)
            ),
          ],
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AddProduct()));
        },

        backgroundColor: green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
Widget _buildHorizontalListView(BuildContext context,{ required String resim, required List<Product> items}) {
  return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final product=items[index];
          return GestureDetector(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=>ProductPage(product: product),
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
                            Text(product.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text("Açıklama: ${product.definition}", style: const TextStyle(fontSize: 16)),
                            Text("Kategori: ${product.category}", style: const TextStyle(fontSize: 16)),
                            Text("Fiyat: ${product.price}", style: const TextStyle(fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
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
