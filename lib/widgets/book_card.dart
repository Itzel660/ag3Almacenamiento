import 'dart:io';
import 'package:flutter/material.dart';
import '../models/libro.dart';
import 'book_detail_screen.dart';

class BookCard extends StatelessWidget {
  final Libro libro;

  const BookCard({super.key, required this.libro});

  Widget _buildImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return Image.asset(
        'assets/no-image.png',
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        File(imageUrl),
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookDetailScreen(libro: libro)),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: _buildImage(libro.imagenUrl),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                libro.titulo,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}





