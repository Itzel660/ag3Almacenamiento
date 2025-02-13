import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatelessWidget {
  final AuthService _authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Método para iniciar sesión con Google
  Future<void> _signInWithGoogle(BuildContext context) async {
    final user = await _authService.signInWithGoogle();
    if (user != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }

  // Método para iniciar sesión de manera anónima (sin correo)
  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await _auth.signInAnonymously();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } catch (e) {
      print("Error en inicio de sesión anónimo: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al iniciar sesión'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Botón para iniciar sesión con Google
            ElevatedButton(
              onPressed: () => _signInWithGoogle(context),
              child: Text('Iniciar sesión con Google'),
            ),
            SizedBox(height: 20),
            // Botón para iniciar sesión como invitado (acceso anónimo)
            ElevatedButton(
              onPressed: () => _signInAnonymously(context),
              child: Text('Entrar como invitado'),
            ),
          ],
        ),
      ),
    );
  }
}

