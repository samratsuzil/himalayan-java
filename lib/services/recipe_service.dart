import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:recipe_book/constants/api.dart';
import '../models/recipe.dart';

class RecipeService {
  static Future<List<Recipe>> fetchRecipes(
      {int? categoryId, String? searchQuery, int? authorId}) async {
    String url = ApiEndpoints.recipes;

    if (categoryId != null) {
      url += '&recipe-categories=$categoryId';
    }

    if (authorId != null) {
      url += '&author=$authorId';
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      url += '&search=$searchQuery';
    }

    log('Fetching recipes from: $url');

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<Recipe> results = [];
      for (var i = 0; i < data.length; i++) {
        try {
          final item = data[i];
          if (item is Map<String, dynamic>) {
            results.add(Recipe.fromJson(item));
          }
        } catch (e, st) {
          log('Error parsing recipe at index $i: $e');
          log('$st');
        }
      }
      return results;
    } else {
      throw Exception('Failed to load recipes: ${response.statusCode}');
    }
  }

  static Future<Recipe> fetchRecipeById(int id) async {
    final url = '${ApiEndpoints.baseUrl}/recipes/$id/?_embed';
    log('Fetching recipe detail from: $url');

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is Map<String, dynamic>) {
        return Recipe.fromJson(data);
      }
      throw Exception('Unexpected recipe response format');
    } else {
      throw Exception('Failed to load recipe $id: ${response.statusCode}');
    }
  }
}
