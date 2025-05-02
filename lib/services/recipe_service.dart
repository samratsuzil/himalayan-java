import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class RecipeService {
  static const String _baseUrl =
      'https://project.astranix.com.np/wp-json/wp/v2/recipes?_embed';

  /// Fetches a list of recipes from the API.
  static Future<List<Recipe>> fetchRecipes() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((item) => Recipe.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load recipes: ${response.statusCode}');
    }
  }
}
