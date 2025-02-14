import 'package:flutter/material.dart';
import '../models/libro.dart';
import '../services/database_service.dart';

class BookDetailScreen extends StatelessWidget {
  final Libro libro;

  const BookDetailScreen({Key? key, required this.libro}) : super(key: key);

  void _deleteBook(BuildContext context) async {
    await DatabaseService().deleteLibro(libro.id); // Llamamos a la función para eliminar
    Navigator.pop(context); // Volvemos a la pantalla anterior
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Libro eliminado exitosamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(libro.titulo),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _deleteBook(context), // Llama a la función de eliminar
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            libro.imagenUrl.isNotEmpty
                ? Image.network(libro.imagenUrl, height: 200, width: double.infinity, fit: BoxFit.cover)
                : Image.asset('assets/no-image.png', height: 200, width: double.infinity, fit: BoxFit.cover),
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

