import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lotus/entity/doctor_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorService {
  final String baseUrl;

  DoctorService({required this.baseUrl});

  Future<List<Doctor>> fetchAndFilterDoctors({
    int? doctorCategoryId,
    bool? sortByAlphabetical,
    bool? sortByAlphabeticalDescending,
    int? pageNumber,
    int? pageSize,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    final url = Uri.parse('$baseUrl/filter/DoctorFilterAndGetAllDoctor')
        .replace(queryParameters: {
      if (doctorCategoryId != null) 'DoctorCategoryId': doctorCategoryId.toString(),
      if (sortByAlphabetical != null) 'SortByAlphabetical': sortByAlphabetical.toString(),
      if (sortByAlphabeticalDescending != null) 'SortByAlphabeticalDescending': sortByAlphabeticalDescending.toString(),
      if (pageNumber != null) 'PageNumber': pageNumber.toString(),
      if (pageSize != null) 'PageSize': pageSize.toString(),
    });

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((doctor) => Doctor.fromJson(doctor)).toList();
    } else {
      throw Exception('Doktorlar yüklenemedi');
    }
  }

  Future<List<Doctor>> searchDoctors(String searchTerm) async {
    final url = Uri.parse('$baseUrl/search/DoctorSearch')
        .replace(queryParameters: {'searchTerm': searchTerm});

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Doctor.fromJson(json)).toList();
    } else {
      throw Exception('Doktorlar aranamadı');
    }
  }

  Future<List<DoctorCategory>> fetchDoctorCategories() async {
    final url = Uri.parse('$baseUrl/doctorCategories');

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => DoctorCategory.fromJson(json)).toList();
    } else {
      throw Exception('Kategoriler yüklenemedi');
    }
  }
}