import 'dart:io';
import 'package:flutter/material.dart';
import '../models/libro.dart';

class BookDetailScreen extends StatelessWidget {
  final Libro libro;

  const BookDetailScreen({Key? key, required this.libro}) : super(key: key);

  Widget _buildImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return Image.asset(
        'assets/no-image.png',
        height: 250,
        fit: BoxFit.cover,
      );
    } else if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        height: 250,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        File(imageUrl),
        height: 250,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(libro.titulo)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: _buildImage(libro.imagenUrl), // Usa la función corregida
              ),
            ),
            SizedBox(height: 20),
            Text(
              libro.titulo,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Autor: ${libro.autor}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[700]),
            ),
            SizedBox(height: 15),
            Text(
              libro.descripcion,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

