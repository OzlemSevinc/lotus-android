import 'package:flutter/material.dart';
import 'package:lotus/renkler.dart';
import 'package:lotus/bilgialma.dart';

class Kayit extends StatefulWidget {
  const Kayit({super.key});

  @override
  State<Kayit> createState() => _KayitState();
}

class _KayitState extends State<Kayit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: anaPembe,
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            margin: const EdgeInsets.only(left: 30,right: 30,top: 100),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 20,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: <Widget>[
                  Text(
                    "Kaydol",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: siyah,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(hint: "Ad"),
                  const SizedBox(height: 20),
                  _buildTextField(hint: "Soyad"),
                  const SizedBox(height: 20),
                  _buildTextField(hint: "E-posta"),
                  const SizedBox(height: 20),
                  _buildTextField(hint: "Şifre", isPassword: true),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const BilgiAlma()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: anaPembe,
                      foregroundColor: beyaz,
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
                        color: siyah, // Adjust as needed
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

  Widget _buildTextField({required String hint, bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        fillColor: beyaz,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
