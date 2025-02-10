import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/libro.dart';
import '../widgets/book_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Catálogo de Libros')),
      body: StreamBuilder<List<Libro>>(
        stream: DatabaseService().getLibros(),  // Obtenemos el stream de libros desde la base de datos
        builder: (context, snapshot) {
          // Si no hay datos, mostramos un indicador de carga
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          // Si hay datos, los mostramos en una cuadrícula
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),  // Dos columnas
            itemCount: snapshot.data!.length,  // El número de libros que se van a mostrar
            itemBuilder: (context, index) {
              // Retornamos una tarjeta para cada libro
              return BookCard(libro: snapshot.data![index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add_book'),  // Para ir a la pantalla de agregar libro
        child: Icon(Icons.add),
      ),
    );
  }
}

