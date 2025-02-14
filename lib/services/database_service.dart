import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/libro.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Obtener los libros desde Firestore
  Stream<List<Libro>> getLibros() {
    return _db.collection('Libros')  // Aquí usamos el nombre correcto de la colección
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Libro.fromJson(doc.data() as Map<String, dynamic>, doc.id))  // Creamos el objeto Libro a partir del JSON
        .toList());
  }

  // ✅ Nueva función para eliminar un libro
  Future<void> deleteBook(String id) async {
    try {
      await _db.collection('Libros').doc(id).delete();
      print("Libro eliminado con éxito");
    } catch (e) {
      print("Error al eliminar el libro: $e");
    }
  }
}


