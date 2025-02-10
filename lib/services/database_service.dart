import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/libro.dart';

class DatabaseService {
  final CollectionReference librosCollection = FirebaseFirestore.instance.collection('libros');

  Future<void> addLibro(Libro libro) async {
    await librosCollection.add(libro.toJson());
  }

  Stream<List<Libro>> getLibros() {
    return librosCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Libro.fromJson(doc.data() as Map<String, dynamic>, doc.id)).toList();
    });
  }
}
