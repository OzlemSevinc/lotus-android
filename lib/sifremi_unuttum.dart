import 'package:flutter/material.dart';
import 'package:lotus/renkler.dart';

class SifremiUnuttum extends StatefulWidget {
  const SifremiUnuttum({super.key});

  @override
  State<SifremiUnuttum> createState() => _SifremiUnuttumState();
}

class _SifremiUnuttumState extends State<SifremiUnuttum> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: anaPembe,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Şifrenizi mi unuttunuz ?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: siyah,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                  Text(
                  'E-posta adresinizi girin. E-posta adresinize şifrenizi sıfırlamanız için bir bağlantı göndereceğiz.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: siyah,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                  const SizedBox(height: 30),
                  const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'E-posta',
                      ),
                    ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: () {

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: anaPembe,
                        foregroundColor: beyaz,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Şifreyi Sıfırla'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


