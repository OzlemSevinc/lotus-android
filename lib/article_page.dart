import 'package:flutter/material.dart';
import 'entity/article_entity.dart';
import 'package:lotus/colors.dart';
class ArticlePage extends StatelessWidget {
  final Article article;

  const ArticlePage({super.key, required this.article});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainPink,
        scrolledUnderElevation: 0.0,
        title: Text(article.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset("resimler/lotus_resim.png"), // Assuming the same image for all articles
            SizedBox(height: 16.0),
            Text(
              article.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              "Yazar: ${article.writer}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8.0),
            Text(
              "Kategori: ${article.category}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16.0),
            Text(
              article.content,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
