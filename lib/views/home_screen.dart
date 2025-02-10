import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/libro.dart';
import '../widgets/book_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo de Libros')),
      body: StreamBuilder<List<Libro>>(
        stream: DatabaseService().getLibros(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) =>
                BookCard(libro: snapshot.data![index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add_book'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
