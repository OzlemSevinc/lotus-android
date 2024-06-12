import 'dart:convert';
import 'dart:io';
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

  Future<int> addProduct(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    final url = Uri.parse('$baseUrl/products');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'productName': product.name,
          'productDefinition': product.definition,
          'ownerId': product.ownerId,
          'price': product.price,
          'categoryId': product.category,
          'productLocation': product.location,
        }));

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['id'];
    } else {
      throw Exception('Ürün eklenemedi');
    }
  }

  Future<void> updateProduct(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    final url = Uri.parse('$baseUrl/products/${product.id}');

    final response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(product.toJson()));

    if (response.statusCode != 200) {
      throw Exception('Ürün güncellenemedi');
    }
  }

  Future<void> deleteProduct(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    final url = Uri.parse('$baseUrl/products/$id');

    final response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode != 204) {
      throw Exception('Ürün silinemedi');
    }
  }



  Future<void> uploadProductImage(int productId, File image) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    final url = Uri.parse('$baseUrl/productPictures/$productId/images');
    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $accessToken'
      ..files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Resim yüklenemedi');
    }
  }

  Future<void> updateProductImage(int imageId, File image) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    final request = http.MultipartRequest(
      'PUT',
      Uri.parse('$baseUrl/productPictures/images/$imageId'),
    );
    request.headers['Authorization'] = 'Bearer $accessToken';
    request.files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();

    if (response.statusCode != 204) {
      throw Exception('Ürün resmi güncellenemedi');
    }
  }

  Future<void> deleteProductImage(int imageId) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    final url = Uri.parse('$baseUrl/productPictures/images/$imageId');

    final response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode != 204) {
      throw Exception('Resim silinemedi');
    }
  }

  Future<List<ProductCategory>> fetchProductCategories() async {
    final url = Uri.parse('$baseUrl/productCategories');

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ProductCategory.fromJson(json)).toList();
    } else {
      throw Exception('Kategoriler yüklenemedi');
    }
  }

}
