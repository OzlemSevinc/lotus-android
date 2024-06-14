import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lotus/colors.dart';
import 'package:lotus/service/appointment_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'entity/appointment_entity.dart';

class AppointmentPage extends StatefulWidget {
  final String doctorId;

  const AppointmentPage({super.key, required this.doctorId});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final AppointmentService appointmentService = AppointmentService(baseUrl: 'https://lotusproject.azurewebsites.net/api/');
  Map<String, List<Appointment>> appointmentsByDay = {};
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    fetchAppointments();
    getCurrentUserId();
  }

  Future<void> getCurrentUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getString('userId');
    });
  }

  Future<void> fetchAppointments() async {
    try {
      final now = DateTime.now();
      final currentMonthYear = DateFormat('MM-yyyy').format(now);

      final appointments = await appointmentService.getDoctorAvailability(widget.doctorId, currentMonthYear);
      final Map<String, List<Appointment>> groupedAppointments = {};

      for (var appointment in appointments) {
        final startTime=DateTime.parse(appointment.startTime);
        final day = appointment.startTime.split('T')[0];
        if (!groupedAppointments.containsKey(day)) {
          groupedAppointments[day] = [];
        }
        if (!appointment.isBooked && startTime.isAfter(now)) {
          groupedAppointments[day]!.add(appointment);
        }
      }

      setState(() {
        appointmentsByDay = groupedAppointments;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Randevular yüklenemedi: $e')),
      );
    }
  }

  Future<void> bookAppointment(String startTime) async {
    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kullanıcı bilgileri alınamadı')),
      );
      return;
    }

    try {
      await appointmentService.bookAppointment(currentUserId!, widget.doctorId, startTime);
      fetchAppointments();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Randevu başarıyla alındı')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Randevu alınamadı: $e')),
      );
    }
  }

  void showConfirmationDialog(String startTime) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Randevuyu onaylıyor musunuz?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Hayır'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Evet'),
              style: ElevatedButton.styleFrom(backgroundColor: mainPink),
              onPressed: () {
                Navigator.of(context).pop();
                bookAppointment(startTime);
              },
            ),
          ],
        );
      },
    );
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainPink,
        title: const Text('Randevu Al'),
      ),
      body: appointmentsByDay.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: appointmentsByDay.keys.length,
        itemBuilder: (context, index) {
          final day = appointmentsByDay.keys.elementAt(index);
          final appointments = appointmentsByDay[day]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  DateFormat('dd-MM-yyyy').format(DateTime.parse(day)),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final appointment = appointments[index];

                  return ListTile(
                    title: Text('Saat: ${appointment.startTime.split('T')[1].substring(0, 5)}'),
                    trailing: ElevatedButton(
                      onPressed: () => showConfirmationDialog(appointment.startTime),
                      style: ElevatedButton.styleFrom(backgroundColor: mainPink),
                      child: const Text('Randevu Al'),
                    ),
                  );
                },
              ),
              Divider(),
            ],
          );
        },
      ),
    );
  }
}
