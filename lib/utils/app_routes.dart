import 'package:flutter/material.dart';
import '../views/home_screen.dart';
import '../views/login_screen.dart';
import '../views/add_book_screen.dart';
import '../views/search_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String addBook = '/add_book';
  static const String search = '/search';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => LoginScreen(),
    home: (context) => HomeScreen(),
    addBook: (context) => AddBookScreen(),
    search: (context) => SearchScreen(),
  };
}
