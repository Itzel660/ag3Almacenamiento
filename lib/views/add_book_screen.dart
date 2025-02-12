import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  // Función para seleccionar una imagen de la galería
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Función para subir la imagen a Firebase Storage
  Future<String?> _uploadImage(File image) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance.ref().child('libros/$fileName');
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error al subir la imagen: $e");
      return null;
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
    // Si no ingresó un link pero subió una imagen, subirla a Firebase Storage
    else if (_image != null) {
      finalImageUrl = await _uploadImage(_image!);
      if (finalImageUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al subir la imagen'),
          backgroundColor: Colors.red,
        ));
        setState(() {
          isUploading = false;
        });
        return;
      }
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

    // Guardar en Firebase
    Libro libro = Libro(
      id: '',
      titulo: tituloController.text,
      autor: autorController.text,
      descripcion: descripcionController.text,
      imagenUrl: finalImageUrl,
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



