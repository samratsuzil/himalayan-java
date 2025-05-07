import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

// Define a model class for User
class RecipeTime {
  final int id;
  final String name;
  final String imageUrl;

  RecipeTime({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}
