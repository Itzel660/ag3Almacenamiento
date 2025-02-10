import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      body: Column(children: [
        const SizedBox(height: 150),
        Center(
          child: Image.asset(
            'assets/logo.png',
            width: 200,
            height: 200,
          ),
        ),
        const SizedBox(height: 40),
        const Center(
          child: Text(
            'App de libros',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 250),
        Padding(
          padding: const EdgeInsets.all(15.0),
          // align to the bottom

          child: ElevatedButton(
            onPressed: () async {
              User? success = await _authService.signInWithGoogle();
              if (success != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: Image.asset(
                      'assets/google.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Iniciar sesión con Google',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
