import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lotus/colors.dart';
import 'package:lotus/entity/user_entity.dart';
import 'package:lotus/service/doctor_service.dart';
import 'package:lotus/service/user_service.dart';
import 'package:lotus/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_page.dart';

class Profile extends StatefulWidget {
  final String userId;

  const Profile({super.key, required this.userId});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? image;
  User? user;
  bool isLoading = true;
  bool isCurrentUser = false;
  final UserService userService = UserService(baseUrl: 'https://lotusproject.azurewebsites.net/api/');
  final DoctorService doctorService = DoctorService(baseUrl: 'https://lotusproject.azurewebsites.net/api/');
  late String currentUserId;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    getCurrentUserId();
  }

  Future<void> getCurrentUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getString('userId')!;
    });
  }

  Future<void> fetchUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final currentUserId = prefs.getString('userId');

    if (currentUserId != null && currentUserId == widget.userId) {
      isCurrentUser = true;
    }

    try {
      final userDetails = await userService.getUserById(widget.userId);
      setState(() {
        user = User(
          name: userDetails['userName'],
          surname: userDetails['surname'],
          email: userDetails['email'],
          pregnancyStatus: userDetails['pregnancyStatus']?.toString(),
          userId: userDetails['id'],
          fetusPicture: userDetails['fetusPicture'],
          userType: userDetails['userType'],
          userImage: userDetails['image'],
        );
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kullanıcı bilgileri alınamadı: $e')),
      );
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
      await userService.updateUser(userId: widget.userId, image: image);
      fetchUserData();
    }
  }

  void imageSourceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Galeri"),
                onTap: () {
                  Navigator.of(context).pop();
                  pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Kamera"),
                onTap: () {
                  Navigator.of(context).pop();
                  pickImage(ImageSource.camera);
                },
              )
            ],
          ),
        );
      },
    );
  }

  Widget buildTabs() {
    return Expanded(
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Randevularım'),
              Tab(text: 'Sorularım'),
              Tab(text: 'Ürünlerim'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                buildAppointments(),
                buildQuestions(),
                buildProducts(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAppointments() {
    final now = DateTime.now();
    final currentMonthYear = DateFormat('MM-yyyy').format(now);
    return FutureBuilder<Map<String, dynamic>>(
      future: doctorService.getUserAppointments(widget.userId, currentMonthYear),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Randevular yüklenemedi: ${snapshot.error}'));
        }
        final appointments = snapshot.data?['appointments'] as List<dynamic>;
        if (appointments.isEmpty) {
          return const Center(child: Text('Randevunuz bulunmamaktadır'));
        }
        return ListView.builder(
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointments[index];
            final DateTime startTime = DateTime.parse(appointment['startTime']);
            final DateTime endTime = DateTime.parse(appointment['endTime']);
            final String formattedStartTime = DateFormat('dd-MM-yyyy HH:mm').format(startTime);
            final String formattedEndTime = DateFormat('dd-MM-yyyy HH:mm').format(endTime);
            print(appointment['appointmentId']);
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: greenQ,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                title: Text(appointment['doctorName']),
                subtitle: Text('Başlangıç: $formattedStartTime\nBitiş: $formattedEndTime'),
                trailing: isCurrentUser
                    ? IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    showCancelAppointmentDialog(appointment['appointmentId']);
                  },
                )
                    : null,
              ),
            );
          },
        );
      },
    );
  }

  void showCancelAppointmentDialog(int appointmentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Randevuyu iptal etmek istiyor musunuz?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Hayır'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Evet'),
              style: ElevatedButton.styleFrom(backgroundColor: deleteRed),
              onPressed: () {
                Navigator.of(context).pop();
                cancelAppointment(appointmentId);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> cancelAppointment(int appointmentId) async {
    final now = DateTime.now();
    final currentMonthYear = DateFormat('MM-yyyy').format(now);
    try {
      await doctorService.cancelAppointment(appointmentId);
      setState(() {
        isLoading = true;
        doctorService.getUserAppointments(widget.userId, currentMonthYear);
      });
      await fetchUserData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Randevu başarıyla iptal edildi')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Randevu iptal edilemedi: $e')),
      );
    }
  }

  Widget buildQuestions() {
    return FutureBuilder(
      future: userService.getUserQuestions(widget.userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Sorular yüklenemedi: ${snapshot.error}'));
        }
        final questions = snapshot.data as List<Map<String, dynamic>>;
        if (questions.isEmpty) {
          return const Center(child: Text('Sorunuz bulunmamaktadır'));
        }
        return ListView.builder(
          itemCount: questions.length,
          itemBuilder: (context, index) {
            final question = questions[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: greenQ,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                title: Text(question['question']),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildProducts() {
    return FutureBuilder(
      future: userService.getUserProducts(widget.userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Ürünler yüklenemedi: ${snapshot.error}'));
        }
        final products = snapshot.data as List<Map<String, dynamic>>;
        if (products.isEmpty) {
          return const Center(child: Text('Ürününüz bulunmamaktadır'));
        }
        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: greenQ,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                title: Text(product['productName']),
                subtitle: Text("${product['price']}"),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainPink,
          actions: [
            if (isCurrentUser)
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
              ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 70,
                            backgroundImage: user?.userImage != null ? NetworkImage(user!.userImage!) : null,
                            child: user?.userImage == null
                                ? Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey[700],
                            )
                                : null,
                          ),
                          if (isCurrentUser)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => imageSourceBottomSheet(context),
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: green,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: coal,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "${user?.name ?? ''} ${user?.surname ?? ''}",
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      if (!isCurrentUser)
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  userId: currentUserId,
                                  otherUserId: widget.userId,
                                ),
                              ),
                            );
                          },
                          child: const Text('Mesaj Yaz'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (isCurrentUser) buildTabs(),
          ],
        ),
      ),
    );
  }
}
