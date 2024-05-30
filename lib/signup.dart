import 'package:flutter/material.dart';
import 'package:lotus/colors.dart';
import 'package:lotus/service/registration_service.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RegistrationService apiService = RegistrationService(baseUrl: 'https://lotusproject.azurewebsites.net/api/');

  Future<void> registration() async {
    try {
      await apiService.registration(
        email: emailController.text,
        userName: nameController.text,
        surname: surnameController.text,
        password: passwordController.text,
      );


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kayıt başarılı.E-posta adresinize onay maili gönderildi')),
      );


      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Login()),
      );

    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kayıt Başarısız: $e')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainPink,
      appBar: AppBar(
        backgroundColor: mainPink,
        scrolledUnderElevation: 0.0,
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
                  _buildTextField(label: "Ad",controller: nameController),
                  const SizedBox(height: 20),
                  _buildTextField(label: "Soyad",controller: surnameController),
                  const SizedBox(height: 20),
                  _buildTextField(label: "E-posta",controller: emailController),
                  const SizedBox(height: 20),
                  _buildTextField(label: "Şifre",controller: passwordController, isPassword: true),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: registration,
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

  Widget _buildTextField({required String label,required TextEditingController controller, bool isPassword = false}) {
    return TextField(
      controller: controller,
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
