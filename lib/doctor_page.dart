import 'package:flutter/material.dart';
import 'package:lotus/colors.dart';
import 'package:lotus/entity/doctor_entity.dart';
import 'package:lotus/service/doctor_service.dart';

class DoctorPage extends StatefulWidget {
  final Doctor doctor;
  const DoctorPage({super.key,required this.doctor});

  @override
  State<DoctorPage> createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  List<DoctorCategory> categories = [];
  final DoctorService doctorService = DoctorService(baseUrl: 'https://lotusproject.azurewebsites.net/api/');

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final fetchedCategories = await doctorService.fetchDoctorCategories();
      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kategoriler yüklenemedi: $e')),
      );
    }
  }

  String getCategoryName(int categoryId) {
    return categories.firstWhere(
          (category) => category.id == categoryId,
      orElse: () => DoctorCategory(id: -1, name: 'Unknown'),
    ).name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainPink,
        scrolledUnderElevation: 0.0,
        title: Text('${widget.doctor.name} ${widget.doctor.surname}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  widget.doctor.image ?? '',
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context,error,stackTrace){
                    return Image.asset("resimler/lotus_resim.png", width: 300,height: 300, fit: BoxFit.cover);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              '${widget.doctor.name} ${widget.doctor.surname}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              '${getCategoryName(widget.doctor.doctorCategoryId)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.doctor.information,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
