import 'package:flutter/material.dart';
import 'package:lotus/colors.dart';
import 'homepage.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  String? selectedWeek;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainPink,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 150),
              Text(
                "Hoşgeldiniz",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "Uygulamayı kişiselleştirmek için lütfen bilgilerinizi giriniz.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 20,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: <Widget>[
                      const Text(
                        "Gebeliğin kaçıncı haftasındasınız?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                       // isExpanded: false,
                        decoration: InputDecoration(
                          labelText: 'Hafta seçiniz',
                          fillColor: white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        value: selectedWeek,
                        items: List.generate(38, (index) => (index + 1).toString())
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text("$value. hafta"),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedWeek = newValue;
                          });
                        },
                      ),
                      const SizedBox(height: 35),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const Homepage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainPink,
                          foregroundColor: white,
                          minimumSize: const Size(double.infinity, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Devam",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {

                        },
                        child: Text(
                          "Hamile değilim",
                          style: TextStyle(
                            color: black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
