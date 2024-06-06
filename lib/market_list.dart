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
  List<Product> products = [];
  final ProductService productService = ProductService(baseUrl: 'https://lotusproject.azurewebsites.net/api/');
  bool isLoading = true;

  String? searchQuery;
  int? minPrice;
  int? maxPrice;
  bool? validPriceRange;
  int? categoryId;
  int? pageNumber;
  int? pageSize;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final fetchedProducts = await productService.fetchandFilterProducts(
        minPrice: minPrice,
        maxPrice: maxPrice,
        validPriceRange: validPriceRange,
        categoryId: categoryId,
        pageNumber: pageNumber,
        pageSize: pageSize
      );
      setState(() {
        products = fetchedProducts;
        //print(products[0].images[0]);
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

  Future<void> searchProducts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final searchedProducts = await productService.searchProducts(searchQuery ?? '');
      setState(() {
        products = searchedProducts;
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

  Widget _buildHorizontalListView(BuildContext context, {required String resim, required List<Product> items}) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final product = items[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductPage(product: product),
              ),
            );
          },
          child: Card(
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    product.images.isNotEmpty ? product.images[0].imageUrl : 'resimler/lotus_resim.png',
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
                        Text(
                          product.name ?? 'Ürün Adı Yok',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "Açıklama: ${product.definition ?? 'Açıklama Yok'}",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Konum: ${product.location ?? 'Konum Yok'}",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Fiyat: ${product.price != null ? product.price.toString() : 'Fiyat Yok'}",
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
            controller.text=searchQuery ?? '';
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
                searchProducts();
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