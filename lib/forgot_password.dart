import 'package:flutter/material.dart';
import 'package:lotus/colors.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainPink,
      appBar: AppBar(
        backgroundColor: mainPink,
      ),
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
                color: black,
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
                    color: black,
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
                        backgroundColor: mainPink,
                        foregroundColor: white,
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


