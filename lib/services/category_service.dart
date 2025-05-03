import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';

class CategoryService {
  static Future<List<Category>> fetchCategories() async {
    final url = Uri.parse(
        'https://project.astranix.com.np/wp-json/wp/v2/recipe-categories/?_embed');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
