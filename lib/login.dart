import 'package:flutter/material.dart';
import 'package:lotus/bottom_nav_bar.dart';
import 'package:lotus/colors.dart';
import 'package:lotus/signup.dart';
import 'package:lotus/forgot_password.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainPink,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 30),
              Image.asset('resimler/lotus_resim.png',width: 1200,height: 250),
              Card(
                margin: const EdgeInsets.only(left: 30,right: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children:<Widget> [
                      Text(
                        "Giriş",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: black,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 40),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "E-posta",
                          fillColor: white,
                          filled: true,
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Şifre",
                          fillColor: white,
                          filled: true,
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const ForgotPassword()),
                            );
                          },
                          child: Text(
                            "Şifremi unuttum!",
                            style: TextStyle(
                              color: black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => const BottomNavigation()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainPink,
                            foregroundColor: white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text("Giriş",
                            style: TextStyle(
                                fontSize: 20
                            ),
                          ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => const SignUp()),
                            );
                          },
                          child: Text(
                            "Hesabınız yok mu? Kaydol",
                            style: TextStyle(
                              color: black,
                              fontSize: 16,
                            ),
                          )
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
