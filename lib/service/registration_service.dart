import 'dart:convert';
import 'package:http/http.dart' as http;

class RegistrationService {
  final String baseUrl;

  RegistrationService({required this.baseUrl});

  Future<void> registration({
    required String email,
    required String userName,
    required String surname,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/authentication/registration');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'userName': userName,
        'surname': surname,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {

    } else {
      throw Exception("Kullanıcı Kaydedilemedi");
    }
  }
}
