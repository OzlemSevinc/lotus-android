import 'package:flutter/material.dart';
import 'package:lotus/renkler.dart';
import 'package:lotus/kayit.dart';
import 'package:lotus/sifremi_unuttum.dart';

class Giris extends StatefulWidget {
  const Giris({super.key});

  @override
  State<Giris> createState() => _GirisState();
}

class _GirisState extends State<Giris> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: anaPembe,
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
                elevation: 20,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children:<Widget> [
                      Text(
                        "Giriş",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: siyah,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 40),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "E-posta",
                          fillColor: beyaz,
                          filled: true,
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Şifre",
                          fillColor: beyaz,
                          filled: true,
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const SifremiUnuttum()),
                            );
                          },
                          child: Text(
                            "Şifremi unuttum!",
                            style: TextStyle(
                              color: siyah,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                      ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: anaPembe,
                            foregroundColor: beyaz,
                            minimumSize: const Size(double.infinity, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
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
                                MaterialPageRoute(builder: (context) => const Kayit()),
                            );
                          },
                          child: Text(
                            "Hesabınız yok mu? Kaydol",
                            style: TextStyle(
                              color: siyah,
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
