import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  final String baseUrl;

  LoginService({required this.baseUrl});

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/authentication/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      final accessToken = responseData['tokenDto']['accessToken'];
      final refreshToken = responseData['tokenDto']['refreshToken'];
      final userId = responseData['id'];

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('accessToken',accessToken);
      await prefs.setString('refreshToken',refreshToken);
      await prefs.setString('userId',userId);
    } else {
      throw Exception('Giriş yapılamadı');
    }
  }
}
