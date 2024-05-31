import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ArticleService {
  final String baseUrl;

  ArticleService({required this.baseUrl});


  Future<List<dynamic>> fetchArticles({int pageNumber = 0, int pageSize = 5}) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    final url = Uri.parse('$baseUrl/filter/ArticleFilterAndGetAllArticles')
        .replace(queryParameters: {
      'PageNumber': pageNumber.toString(),
      'PageSize': pageSize.toString(),
    });

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load articles');
    }
  }
}
