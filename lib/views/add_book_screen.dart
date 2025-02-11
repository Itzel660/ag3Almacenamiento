import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/libro.dart';

class AddBookScreen extends StatefulWidget {
  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController autorController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController imagenUrlController = TextEditingController(); // NUEVO: Para ingresar la URL de la imagen
  bool isUploading = false;

  Future<void> _saveBook() async {
    if (tituloController.text.isEmpty || imagenUrlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Debe ingresar un título y un enlace de imagen válido'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    setState(() {
      isUploading = true;
    });

    Libro libro = Libro(
      id: '',
      titulo: tituloController.text,
      autor: autorController.text,
      descripcion: descripcionController.text,
      imagenUrl: imagenUrlController.text, // USA EL LINK EN LUGAR DE SUBIR IMAGEN
    );

    await FirebaseFirestore.instance.collection('Libros').add(libro.toJson());

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Libro agregado con éxito'),
      backgroundColor: Colors.green,
    ));

    setState(() {
      isUploading = false;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Libro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: tituloController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: autorController,
              decoration: InputDecoration(labelText: 'Autor'),
            ),
            TextField(
              controller: descripcionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            TextField(
              controller: imagenUrlController,
              decoration: InputDecoration(labelText: 'URL de la Imagen'), // NUEVO CAMPO PARA INGRESAR LINK
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveBook,
              child: Text('Guardar Libro'),
            ),
          ],
        ),
      ),
    );
  }
}


