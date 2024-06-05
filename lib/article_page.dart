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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  article.image ?? '',
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context,error,stackTrace){
                    return Image.asset("resimler/lotus_resim.png", width: 300,height: 300, fit: BoxFit.cover);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              article.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              "Yazar: ${article.writer}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            Text(
              "Yayınlanma Tarihi: ${article.date}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              article.content,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
