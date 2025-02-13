import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/libro.dart';

class AddBookScreen extends StatefulWidget {
  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController autorController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController imagenUrlController = TextEditingController();

  File? _image; // Imagen seleccionada desde la galería
  bool isUploading = false;

  // Función para seleccionar una imagen y guardarla localmente
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Obtener el directorio de almacenamiento local
      final directory = await getApplicationDocumentsDirectory();
      final localImagePath = path.join(directory.path, path.basename(pickedFile.path));

      // Guardar la imagen localmente
      final File localImage = await File(pickedFile.path).copy(localImagePath);

      setState(() {
        _image = localImage;
      });
    }
  }

  Future<void> _saveBook() async {
    if (tituloController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Debe ingresar un título'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    setState(() {
      isUploading = true;
    });

    String? finalImageUrl;

    // Si el usuario ingresó un link, usarlo
    if (imagenUrlController.text.isNotEmpty) {
      finalImageUrl = imagenUrlController.text;
    }
    // Si no ingresó un link pero seleccionó una imagen, usar la ruta local
    else if (_image != null) {
      finalImageUrl = _image!.path;
    }
    // Si no hay imagen ni URL, mostrar error
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Debe ingresar un enlace de imagen o subir una imagen'),
        backgroundColor: Colors.red,
      ));
      setState(() {
        isUploading = false;
      });
      return;
    }

    // Guardar en Firebase Firestore
    Libro libro = Libro(
      id: '',
      titulo: tituloController.text,
      autor: autorController.text,
      descripcion: descripcionController.text,
      imagenUrl: finalImageUrl, // Guarda la URL o la ruta local
    );

    await FirebaseFirestore.instance.collection('Libros').add(libro.toJson());

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Libro agregado con éxito'),
      backgroundColor: Colors.green,
    ));

    setState(() {
      isUploading = false;
      tituloController.clear();
      autorController.clear();
      descripcionController.clear();
      imagenUrlController.clear();
      _image = null;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Libro')),
      body: SingleChildScrollView(
        child: Padding(
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
              SizedBox(height: 10),
              TextField(
                controller: imagenUrlController,
                decoration: InputDecoration(labelText: 'URL de la Imagen (opcional)'),
              ),
              SizedBox(height: 10),
              _image != null
                  ? Image.file(_image!, height: 150, width: 150, fit: BoxFit.cover)
                  : Text('No se ha seleccionado imagen'),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Seleccionar Imagen desde Galería'),
              ),
              SizedBox(height: 10),
              isUploading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _saveBook,
                child: Text('Guardar Libro'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




