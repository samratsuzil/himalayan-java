import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class RecipeService {
  static const String _baseUrl =
      'https://project.astranix.com.np/wp-json/wp/v2/recipes?_embed';

  /// Fetches a list of recipes from the API with optional filtering by search and category.
  static Future<List<Recipe>> fetchRecipes(
      {int? categoryId, String? searchQuery}) async {
    String url = _baseUrl;

    // Add category filter if a category ID is provided
    if (categoryId != null) {
      url += '&recipe-categories=$categoryId';
    }

    // Add search query if provided
    if (searchQuery != null && searchQuery.isNotEmpty) {
      url += '&search=$searchQuery';
    }

    // Log the URL for debugging purposes
    print('Fetching recipes from: $url');

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      // Log the data to check what is returned
      print('Received data: $data');

      return data
          .map((item) => Recipe.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load recipes: ${response.statusCode}');
    }
  }
}
