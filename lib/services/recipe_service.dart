import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:recipe_book/constants/api.dart';
import '../models/recipe.dart';

class RecipeService {
  static Future<List<Recipe>> fetchRecipes(
      {int? categoryId, String? searchQuery}) async {
    String url = ApiEndpoints.recipes;

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

      return data
          .map((item) => Recipe.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load recipes: ${response.statusCode}');
    }
  }
}
