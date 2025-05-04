import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class RecipeService {
  static const String _baseUrl =
      'https://project.astranix.com.np/wp-json/wp/v2/recipes?_embed';

  static Future<List<Recipe>> fetchRecipes(
      {int? categoryId, String? searchQuery}) async {
    String url = _baseUrl;

    if (categoryId != null) {
      url += '&recipe-categories=$categoryId';
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      url += '&search=$searchQuery';
    }

    log('Fetching recipes from: $url');

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      log('Received data: $data');

      return data
          .map((item) => Recipe.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load recipes: ${response.statusCode}');
    }
  }
}
