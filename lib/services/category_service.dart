import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe_book/constants/api.dart';
import '../models/category.dart';

class CategoryService {
  static Future<List<Category>> fetchCategories() async {
    final url = Uri.parse(ApiEndpoints.categories);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
