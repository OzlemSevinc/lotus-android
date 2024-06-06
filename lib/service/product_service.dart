import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../entity/product_entity.dart';

class ProductService {
  final String baseUrl;

  ProductService({required this.baseUrl});

  Future<List<Product>> fetchandFilterProducts({
    int? minPrice,
    int? maxPrice,
    bool? validPriceRange,
    int? categoryId,
    int? pageNumber,
    int? pageSize,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    final url = Uri.parse('$baseUrl/filter/ProductFilterAndGetAllProducts')
        .replace(queryParameters: {
      if(minPrice != null) 'MinPrice' : minPrice.toString(),
      if(maxPrice != null) 'MaxPrice' : maxPrice.toString(),
      if(validPriceRange != null) 'ValidPriceRange' : validPriceRange.toString(),
      if(categoryId != null) 'CategoryId' : categoryId.toString(),
      if(pageNumber != null) 'PageNumber': pageNumber.toString(),
      if(pageSize != null)'PageSize': pageSize.toString(),


    });

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['productDtos'] ?? [];
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Ürünler yüklenemedi');
    }
  }

  Future<List<Product>> searchProducts(String productName) async {
    final url = Uri.parse('$baseUrl/search/ProductSearch')
        .replace(queryParameters: {'productName': productName});

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      print(response.body);
      final List<dynamic> data = jsonDecode(response.body) ?? [];
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Ürünler aranamadı');
    }
  }
}
