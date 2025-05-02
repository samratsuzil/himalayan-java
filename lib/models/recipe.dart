import 'ingredient_group.dart';
import 'procedure_group.dart';

class Recipe {
  final String name;
  final int servings;
  final int calories;
  final String difficulty;
  final String videoUrl;
  final List<IngredientGroup> ingredients;
  final List<ProcedureGroup> procedures;
  final String? featuredImage;

  Recipe({
    required this.name,
    required this.servings,
    required this.calories,
    required this.difficulty,
    required this.videoUrl,
    required this.ingredients,
    required this.procedures,
    this.featuredImage,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final acf = json['acf'] ?? {};
    final info = acf['info'] ?? {};
    final embedded = json['_embedded'] ?? {};
    String? imageUrl;

    // Extract featured image from _embedded
    if (embedded['wp:featuredmedia'] != null &&
        embedded['wp:featuredmedia'].isNotEmpty) {
      imageUrl = embedded['wp:featuredmedia'][0]['source_url'];
    }

    final ingredientsJson = acf['ingredients'] ?? [];
    final proceduresJson = acf['procedures'] ?? [];

    return Recipe(
      name: info['recipe_name'] ?? '',
      servings: info['number_of_servings'] ?? 0,
      calories: info['recipe_calories'] ?? 0,
      difficulty: info['recipe_difficulty'] ?? '',
      videoUrl: info['preparation_video'] ?? '',
      ingredients: List<Map<String, dynamic>>.from(ingredientsJson)
          .map((e) => IngredientGroup.fromJson(e))
          .toList(),
      procedures: List<Map<String, dynamic>>.from(proceduresJson)
          .map((e) => ProcedureGroup.fromJson(e))
          .toList(),
      featuredImage: imageUrl,
     
    );
  }
}
