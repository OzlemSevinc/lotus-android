import 'package:flutter/material.dart';
import 'package:lotus/colors.dart';
import 'package:lotus/entity/product_entity.dart';

class ProductPage extends StatelessWidget {
  final Product product;

  const ProductPage({super.key, required this.product});


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
                    itemCount: product.images.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        product.images[index].imageUrl,
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
              product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              "Satıcı: ${product.ownerId}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            Text(
              "Konum: ${product.location}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            Text(
              "Fiyat: ${product.price} ₺",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),
            Text(
              product.definition,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
