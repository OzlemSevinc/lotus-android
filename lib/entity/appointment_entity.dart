class Appointment {
  final int scheduleId;
  final String startTime;
  final bool isBooked;

  Appointment({required this.scheduleId, required this.startTime, required this.isBooked});

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      scheduleId: json['scheduleId'],
      startTime: json['startTime'],
      isBooked: json['isBooked'],
    );
  }
}