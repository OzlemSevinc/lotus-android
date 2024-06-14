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
  int? selectedCategory;
  String? selectedCity;
  List<String> cities = ["Adana", "Adıyaman", "Afyonkarahisar", "Ağrı", "Amasya", "Ankara", "Antalya", "Artvin", "Aydın", "Balıkesir",
    "Bilecik", "Bingöl", "Bitlis", "Bolu", "Burdur", "Bursa", "Çanakkale", "Çankırı", "Çorum", "Denizli", "Diyarbakır",
    "Edirne", "Elazığ", "Erzincan", "Erzurum", "Eskişehir", "Gaziantep", "Giresun", "Gümüşhane", "Hakkari", "Hatay", "Isparta", "Mersin",
    "İstanbul", "İzmir", "Kars", "Kastamonu", "Kayseri", "Kırklareli", "Kırşehir", "Kocaeli", "Konya", "Kütahya", "Malatya", "Manisa",
    "Kahramanmaraş", "Mardin", "Muğla", "Muş", "Nevşehir", "Niğde", "Ordu", "Rize", "Sakarya", "Samsun", "Siirt",
    "Sinop", "Sivas", "Tekirdağ", "Tokat", "Trabzon", "Tunceli", "Şanlıurfa", "Uşak", "Van", "Yozgat", "Zonguldak",
    "Aksaray", "Bayburt", "Karaman", "Kırıkkale", "Batman", "Şırnak", "Bartın", "Ardahan", "Iğdır", "Yalova", "Karabük", "Kilis", "Osmaniye", "Düzce"
  ];
  List<ProductCategory> categories = [];
  bool isLoading = true;

  String? searchQuery;
  int? minPrice;
  int? maxPrice;
  bool? validPriceRange;
  bool? sortByDate;
  bool? sortByDateAscending;
  bool? sortByPrice;
  bool? sortByPriceAscending;
  int? categoryId;
  int? pageNumber;
  int? pageSize=100;

  @override
  void initState() {
    super.initState();
    fetchProducts();
    fetchCategories();
  }
  Future<void> fetchCategories() async {
    try {
      final fetchedCategories = await productService.fetchProductCategories();
      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kategoriler yüklenemedi: $e')),
      );
    }
  }

  Future<void> fetchProducts() async {
    try {
      final fetchedProducts = await productService.fetchandFilterProducts(
        minPrice: minPrice,
        maxPrice: maxPrice,
        validPriceRange: validPriceRange,
        categoryId: selectedCategory,
        city:selectedCity,
        sortByDate: sortByDate,
        sortByDateAscending: sortByDateAscending,
        sortByPrice: sortByPrice,
        sortByPriceAscending: sortByDateAscending,
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

  void showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              height: MediaQuery.of(context).size.height * 0.6,
              child: Wrap(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButton<int>(
                        hint: Text("Kategori seçiniz"),
                        value: selectedCategory,
                        onChanged: (int? value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                        items: categories.map((category) {
                          return DropdownMenuItem(
                            child: Text(category.name),
                            value: category.id,
                          );
                        }).toList(),
                        isExpanded: true,
                      ),
                      SizedBox(height: 16.0),
                      DropdownButton<String>(
                        hint: Text("Şehir seçiniz"),
                        value: selectedCity,
                        onChanged: (String? value) {
                          setState(() {
                            selectedCity = value;
                          });
                        },
                        items: cities.map((city) {
                          return DropdownMenuItem(
                            child: Text(city),
                            value: city,
                          );
                        }).toList(),
                        isExpanded: true,
                      ),
                      SizedBox(height: 16.0),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Minimum Fiyat',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            minPrice = int.tryParse(value);
                          });
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Maksimum Fiyat',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            maxPrice = int.tryParse(value);
                          });
                        },
                      ),
                      SizedBox(height: 32.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            fetchProducts();
                          },
                          child: Text("Uygula"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void showSortDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text("Tarihe Göre Sırala (Yeni)"),
                        leading: Radio<bool>(
                          value: true,
                          groupValue: sortByDate,
                          onChanged: (bool? value) {
                            setState(() {
                              sortByDate = value;
                              sortByDateAscending = false;
                              sortByPrice = false;
                              sortByPriceAscending = false;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: Text("Tarihe Göre Sırala (Eski)"),
                        leading: Radio<bool>(
                          value: true,
                          groupValue: sortByDateAscending,
                          onChanged: (bool? value) {
                            setState(() {
                              sortByDate = false;
                              sortByDateAscending = value;
                              sortByPrice = false;
                              sortByPriceAscending = false;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: Text("Fiyata Göre Sırala (Artan)"),
                        leading: Radio<bool>(
                          value: true,
                          groupValue: sortByPrice,
                          onChanged: (bool? value) {
                            setState(() {
                              sortByDate = false;
                              sortByDateAscending = false;
                              sortByPrice = value;
                              sortByPriceAscending = false;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: Text("Fiyata Göre Sırala (Azalan)"),
                        leading: Radio<bool>(
                          value: true,
                          groupValue: sortByPriceAscending,
                          onChanged: (bool? value) {
                            setState(() {
                              sortByDate = false;
                              sortByDateAscending = false;
                              sortByPrice = false;
                              sortByPriceAscending = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 16.0),
                      SizedBox(
                        width: 400,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            fetchProducts();
                          },
                          child: Text("Uygula"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
          filterAndSortButtons(),
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
        onPressed: () async{
          final result = await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AddProduct(title: "Ürün ekleme",)));
          if (result == true) {
            fetchProducts();
          }
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
                          product.name ,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "Açıklama: ${product.definition }",
                          style: TextStyle(fontSize: 16),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "Konum: ${product.location }",
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
  Widget filterAndSortButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: ElevatedButton.icon(
              onPressed: () => showFilterDialog(context),
              icon: Icon(Icons.filter_list),
              label: Text("Filtrele"),
              style: ElevatedButton.styleFrom(
                primary: mainPink,
                onPrimary: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: ElevatedButton.icon(
              onPressed: () => showSortDialog(context),
              icon: Icon(Icons.sort),
              label: Text("Sırala"),
              style: ElevatedButton.styleFrom(
                primary: mainPink,
                onPrimary: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}