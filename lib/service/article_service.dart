import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lotus/entity/article_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArticleService {
  final String baseUrl;

  ArticleService({required this.baseUrl});



  Future<List<Article>> fetchandFilterArticles({
    int? categoryId,
    bool? sortByAlphabetical,
    bool? sortByAlphabeticalDescending,
    bool? sortByDate,
    bool? sortByDateAscending,
    int? pageNumber ,
    int? pageSize ,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    final url = Uri.parse('$baseUrl/filter/ArticleFilterAndGetAllArticles')
        .replace(queryParameters: {
      if (categoryId != null) 'ArticleCategoryId': categoryId.toString(),
      if (sortByAlphabetical != null) 'SortByAlphabetical': sortByAlphabetical.toString(),
      if (sortByAlphabeticalDescending != null) 'SortByAlphabeticalDescending': sortByAlphabeticalDescending.toString(),
      if (sortByDate != null) 'SortByDate': sortByDate.toString(),
      if (sortByDateAscending != null) 'SortByDateAscending': sortByDateAscending.toString(),
      if(pageNumber != null) 'PageNumber': pageNumber.toString(),
      if(pageSize != null)'PageSize': pageSize.toString(),
    });

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Makaleler yüklenemedi');
    }
  }

  Future<List<Article>> searchArticles(String title) async {
    final url = Uri.parse('$baseUrl/search/ArticleSearch')
        .replace(queryParameters: {'title': title});

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Makaleler aranamadı');
    }
  }
}
