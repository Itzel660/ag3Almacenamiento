import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/libro.dart';
import '../widgets/book_card.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchQuery = ''; // 🔹 Variable para guardar el texto de búsqueda

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buscar Libro')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Ingrese el título del libro',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase().trim(); // 🔹 Convertimos el texto a minúsculas y eliminamos espacios extra
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Libros')
                  .snapshots(), // 🔹 Obtenemos todos los libros
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                // 🔹 Filtrar los libros según el texto ingresado
                final Libros = snapshot.data!.docs
                    .map((doc) => Libro.fromJson(doc.data() as Map<String, dynamic>, doc.id))
                    .where((libro) =>
                    libro.titulo.toLowerCase().contains(searchQuery)) // 🔹 Filtra los títulos que contienen el texto de búsqueda
                    .toList();

                // 🔹 Si no hay resultados, mostrar un mensaje
                if (Libros.isEmpty) {
                  return Center(child: Text('No se encontraron libros'));
                }

                return ListView.builder(
                  itemCount: Libros.length,
                  itemBuilder: (context, index) => BookCard(libro: Libros[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



