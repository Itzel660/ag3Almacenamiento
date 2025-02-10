class Libro {
  final String id;  // ID del libro, necesario para actualizar o eliminar si es necesario
  final String titulo;
  final String autor;
  final String descripcion;
  final String imagenUrl;

  Libro({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.descripcion,
    required this.imagenUrl,
  });

  // Convertir el documento de Firestore a un objeto Libro
  factory Libro.fromJson(Map<String, dynamic> json, String id) {
    return Libro(
      id: id,
      titulo: json['titulo'] ?? '',
      autor: json['autor'] ?? '',
      descripcion: json['descripcion'] ?? '',
      imagenUrl: json['imagenUrl'] ?? '', // Si no hay imagen, lo dejamos vacío
    );
  }

  // Convertir el objeto Libro a JSON para guardarlo en Firestore
  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'autor': autor,
      'descripcion': descripcion,
      'imagenUrl': imagenUrl,  // Si no hay imagen, este campo estará vacío
    };
  }
}



