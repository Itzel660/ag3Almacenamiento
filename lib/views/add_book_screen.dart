import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  File? _image;
  bool isUploading = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

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
    if (tituloController.text.isEmpty || _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Debe ingresar un título y seleccionar una imagen'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    setState(() {
      isUploading = true;
    });

    String? imageUrl = await _uploadImage(_image!);
    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al subir la imagen'),
        backgroundColor: Colors.red,
      ));
      setState(() {
        isUploading = false;
      });
      return;
    }

    Libro libro = Libro(
      id: '',
      titulo: tituloController.text,
      autor: autorController.text,
      descripcion: descripcionController.text,
      imagenUrl: imageUrl,
    );

    await FirebaseFirestore.instance.collection('libros').add(libro.toJson());

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
            SizedBox(height: 10),
            _image != null
                ? Image.file(_image!, height: 150, width: 150, fit: BoxFit.cover)
                : Text('No se ha seleccionado imagen'),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Seleccionar Imagen'),
            ),
            SizedBox(height: 10),
            isUploading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _saveBook,
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}

