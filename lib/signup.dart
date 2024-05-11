import 'package:flutter/material.dart';
import 'package:lotus/colors.dart';
import 'package:lotus/user_info.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainPink,
      appBar: AppBar(
        backgroundColor: mainPink,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            margin: const EdgeInsets.only(left: 30,right: 30,top: 100),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),

            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: <Widget>[
                  Text(
                    "Kaydol",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: black,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(label: "Ad"),
                  const SizedBox(height: 20),
                  _buildTextField(label: "Soyad"),
                  const SizedBox(height: 20),
                  _buildTextField(label: "E-posta"),
                  const SizedBox(height: 20),
                  _buildTextField(label: "Şifre", isPassword: true),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const UserInfo()),
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
                    child: const Text("Kaydol",
                    style: TextStyle(
                      fontSize: 20,
                    ),),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Hesabınız var mı? Giriş Yap",
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
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        fillColor: white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
