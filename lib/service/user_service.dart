import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final String baseUrl;

  UserService({required this.baseUrl});

  Future<Map<String, dynamic>> getUserById(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      throw Exception('Access token is missing');
    }

    final url = Uri.parse('$baseUrl/user/$userId');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Kullanıcı bilgileri alınamadı');
    }
  }

  Future<void> updateUser({
    required String userId,
    String? userName,
    String? surname,
    String? pregnancyStatus,
    String? email,
    File? image,
  }) async {
    final url = Uri.parse('$baseUrl/user/$userId');
    final request = http.MultipartRequest('PUT', url)
      ..fields['userName'] = userName ?? ''
      ..fields['surname'] = surname ?? ''
      ..fields['pregnancyStatus'] = pregnancyStatus ?? ''
      ..fields['email'] = email ?? '';

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Kullanıcı güncellenemedi');
    }
  }
}