import 'package:flutter/material.dart';
import 'package:lotus/add_product.dart';
import 'package:lotus/colors.dart';
import 'package:lotus/product_page.dart';
import 'package:lotus/service/product_service.dart';
import 'article_list.dart';
import 'entity/product_entity.dart';

class MarketList extends StatefulWidget {
  const MarketList({super.key});

  @override
  State<MarketList> createState() => _MarketListState();
}

class _MarketListState extends State<MarketList> {
  List<dynamic> products = [];
  final ProductService productService = ProductService(baseUrl: 'https://lotusproject.azurewebsites.net/api/');
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final fetchedProducts = await productService.fetchProducts();
      setState(() {
        products = fetchedProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ürünler yüklenemedi: $e')),
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: <Widget>[
          _searchBar(context),
          Expanded(
            child: _buildHorizontalListView(
              context,
              resim: "resimler/lotus_resim.png",
              items: products,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AddProduct()));
        },

        backgroundColor: green,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHorizontalListView(BuildContext context, {required String resim, required List<dynamic> items}) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final product = items[index];
        return Card(
          child: Row(
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: Image.network(
                  product['productImages'][0]['imageUrl'] ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(resim, fit: BoxFit.cover);
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
                        product['productName'] ?? 'Ürün Adı Yok',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "Açıklama: ${product['productDefinition'] ?? 'Açıklama Yok'}",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Konum: ${product['productLocation'] ?? 'Konum Yok'}",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Fiyat: ${product['price'] != null ? product['price'].toString() : 'Fiyat Yok'}",
                        style: TextStyle(fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
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