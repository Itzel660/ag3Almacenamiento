import 'dart:io';
import 'package:flutter/material.dart';
import '../models/libro.dart';
import '../services/database_service.dart';

class BookDetailScreen extends StatelessWidget {
  final Libro libro;

  const BookDetailScreen({super.key, required this.libro});

  void _deleteBook(BuildContext context) async {
    await DatabaseService().deleteLibro(libro.id);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Libro eliminado exitosamente')),
    );
  }

  Widget _buildImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return Image.asset(
        'assets/no-image.png',
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        File(imageUrl),
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(libro.titulo),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _deleteBook(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(libro.imagenUrl), // Usamos la nueva función
            SizedBox(height: 10),
            Text(libro.titulo, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Autor: ${libro.autor}", style: TextStyle(fontSize: 18, color: Colors.grey[700])),
            SizedBox(height: 10),
            Text(libro.descripcion, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}


