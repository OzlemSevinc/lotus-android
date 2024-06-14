import 'dart:convert';
import 'package:http/http.dart' as http;

import '../entity/appointment_entity.dart';

class AppointmentService {
  final String baseUrl;

  AppointmentService({required this.baseUrl});

  Future<List<Appointment>> getDoctorAvailability(String doctorId, String month) async {
    final response = await http.get(Uri.parse('$baseUrl/appointments/doctor/$doctorId/availability?month=$month'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((appointment) => Appointment.fromJson(appointment)).toList();
    } else {
      throw Exception('Uygun randevular yüklenemedi');
    }
  }

  Future<void> bookAppointment(String userId, String doctorId, String startTime) async {
    final response = await http.post(
      Uri.parse('$baseUrl/appointments'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userId': userId,
        'doctorId': doctorId,
        'startTime': startTime,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Randevu alınamadı');
    }
  }
}


