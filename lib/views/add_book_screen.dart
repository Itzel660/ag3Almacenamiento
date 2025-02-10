import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../services/storage_service.dart';
import '../models/libro.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  String titulo = '';
  String autor = '';
  String descripcion = '';
  File? imagen;

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => imagen = File(pickedFile.path));
    }
  }

  Future<void> saveBook() async {
    if (imagen == null) return;
    String imageUrl = await StorageService().uploadImage(imagen!);
    Libro libro = Libro(
        id: '',
        titulo: titulo,
        autor: autor,
        descripcion: descripcion,
        imagenUrl: imageUrl);
    await DatabaseService().addLibro(libro);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Libro')),
      body: Column(
        children: [
          TextField(
              onChanged: (val) => titulo = val,
              decoration: const InputDecoration(labelText: 'Título')),
          ElevatedButton(
              onPressed: pickImage, child: const Text('Seleccionar Imagen')),
          ElevatedButton(onPressed: saveBook, child: const Text('Guardar')),
        ],
      ),
    );
  }
}
