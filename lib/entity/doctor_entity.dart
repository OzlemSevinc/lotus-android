class Doctor{
  String userId;
  String name;
  String surname;
  String? email;
  int doctorCategoryId;
  String information;
  String image;

  Doctor({required this.userId,required this.name,required this.surname,required this.email,required this.doctorCategoryId,required this.information,required this.image});

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      userId: json['userId'] ?? '',
      name: json['userName'] ?? '',
      surname: json['surname'] ?? '',
      email: json['email'] ?? '',
      doctorCategoryId: json['doctorCategoryId'] ?? 0,
      information: json['information'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class DoctorCategory {
  final int id;
  final String name;

  DoctorCategory({required this.id, required this.name});

  factory DoctorCategory.fromJson(Map<String, dynamic> json) {
    return DoctorCategory(
      id: json['doctorCategoryId'],
      name: json['doctorCategoryName'],
    );
  }
}