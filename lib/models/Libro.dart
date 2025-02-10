class Libro {
  String id;
  String titulo;
  String autor;
  String descripcion;
  String imagenUrl;

  Libro({required this.id, required this.titulo, required this.autor, required this.descripcion, required this.imagenUrl});

  factory Libro.fromJson(Map<String, dynamic> json, String id) {
    return Libro(
      id: id,
      titulo: json['titulo'],
      autor: json['autor'],
      descripcion: json['descripcion'],
      imagenUrl: json['imagenUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'autor': autor,
      'descripcion': descripcion,
      'imagenUrl': imagenUrl,
    };
  }
}

