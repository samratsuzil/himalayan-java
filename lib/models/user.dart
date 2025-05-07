import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:recipe_book/constants/api.dart';

// Define a model class for User
class User {
  final int id;
  final String name;
  final String imageUrl;

  User({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
    );
  }
}

// Update the fetch function to return User
Future<User?> fetchUser(int id) async {
  try {
    final response = await http.get(
      Uri.parse('${ApiEndpoints.users}/$id'),
    );
    log('Fetching user data from: ${response.request?.url}');
    log('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    }
  } catch (e) {
    log('Error fetching user for ID $id: $e');
  }
  return null;
}
