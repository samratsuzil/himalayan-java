import 'package:recipe_book/models/models.dart';

class Recipe {
  final String name;
  final int servings;
  final int calories;
  final String difficulty;
  final String videoUrl;
  final List<dynamic> ingredients;
  final List<dynamic> procedures;
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

    if (embedded['wp:featuredmedia'] != null &&
        embedded['wp:featuredmedia'].isNotEmpty) {
      imageUrl = embedded['wp:featuredmedia'][0]['source_url'];
    }

    final ingredientsJson = acf['ingredients'] ?? [];
    final proceduresJson = acf['procedures'] ?? [];

    List<dynamic> parsedIngredients = [];
    for (var ingredient in ingredientsJson) {
      if (ingredient.containsKey('sub_ingredients')) {
        parsedIngredients.add(IngredientGroup.fromJson(ingredient));
      } else {
        parsedIngredients
            .add(IngredientItem.fromJson(ingredient['ingredient']));
      }
    }

    List<dynamic> parsedProcedures = [];
    for (var procedure in proceduresJson) {
      if (procedure.containsKey('sub_procedure')) {
        parsedProcedures.add(ProcedureGroup.fromJson(procedure));
      } else {
        parsedProcedures.add(ProcedureStep.fromJson(procedure['procedure']));
      }
    }

    return Recipe(
      name: json['title']['rendered'] ?? '',
      servings: info['number_of_servings'] ?? 0,
      calories: info['recipe_calories'] ?? 0,
      difficulty: info['recipe_difficulty'] ?? '',
      videoUrl: info['preparation_video'] ?? '',
      ingredients: parsedIngredients,
      procedures: parsedProcedures,
      featuredImage: imageUrl,
    );
  }
}
