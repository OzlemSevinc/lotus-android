import 'package:flutter/material.dart';
import 'package:lotus/colors.dart';
import 'package:lotus/entity/product_entity.dart';
import 'package:lotus/profile.dart';
import 'package:lotus/service/product_service.dart';
import 'package:lotus/service/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_product.dart';
import 'chat_page.dart';

class ProductPage extends StatefulWidget  {
  final Product product;

  const ProductPage({super.key, required this.product});
  @override
  _ProductPageState createState() => _ProductPageState();
}
class _ProductPageState extends State<ProductPage> {
  String? currentUserId;
  String? ownerName;
  final ProductService productService = ProductService(baseUrl: 'https://lotusproject.azurewebsites.net/api/');
  final UserService userService = UserService(baseUrl: 'https://lotusproject.azurewebsites.net/api/');

  @override
  void initState() {
    super.initState();
    getCurrentUserId();
    fetchOwnerDetails();
  }

  Future<void> getCurrentUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getString('userId');
    });
  }

  Future<void> fetchOwnerDetails() async {
    try {
      final userDetails = await userService.getUserById(widget.product.ownerId);
      setState(() {
        ownerName = '${userDetails['userName']} ${userDetails['surname']}';
      });
    } catch (e) {
      print('Satıcı bilgileri alınamadı: $e');
    }
  }

  void updateProduct() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddProduct(product: widget.product,title: "Ürün güncelleme",),
      ),
    );
  }

  Future<void> deleteProduct() async {
    try {
      await productService.deleteProduct(widget.product.id);
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ürün silinemedi: $e')),
      );
    }
  }

  void navigateToOwnerProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Profile(userId: widget.product.ownerId),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainPink,
        scrolledUnderElevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: SizedBox(
                  height: 300,
                  child: PageView.builder(
                    itemCount: widget.product.images.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        widget.product.images[index].imageUrl,
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset("resimler/lotus_resim.png", width: 300, height: 300, fit: BoxFit.cover);
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              widget.product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            GestureDetector(
              onTap: navigateToOwnerProfile,
              child: Text(
                "Satıcı: $ownerName",
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              "Konum: ${widget.product.location}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            Text(
              "Fiyat: ${widget.product.price} ₺",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),
            Text(
              widget.product.definition,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            if (currentUserId == widget.product.ownerId)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: updateProduct,
                    style: ElevatedButton.styleFrom(backgroundColor: mainPink),
                    child: const Text("Ürünü Güncelle"),
                  ),
                  ElevatedButton(
                    onPressed: deleteProduct,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text("Ürünü Sil"),
                  ),
                ],
              )
            else
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          userId: currentUserId!,
                          otherUserId: widget.product.ownerId,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: mainPink),
                  child: const Text("Mesaj Yaz"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
