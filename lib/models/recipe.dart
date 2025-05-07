import 'package:recipe_book/models/models.dart';
import 'package:html_unescape/html_unescape.dart';

class Recipe {
  final String name;
  final int servings;
  final int calories;
  final String difficulty;
  final String videoUrl;
  final List<dynamic> ingredients;
  final List<dynamic> procedures;
  final String? featuredImage;
  final int author;
  final String? prepTime;
  final String? cookTime;

  Recipe(
      {required this.name,
      required this.servings,
      required this.calories,
      required this.difficulty,
      required this.videoUrl,
      required this.ingredients,
      required this.procedures,
      this.featuredImage,
      required this.author,
      this.prepTime,
      this.cookTime});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final acf = json['acf'] ?? {};
    final time = acf['time'] ?? {};

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
        name: HtmlUnescape().convert(json['title']['rendered'] ?? ''),
        servings: info['number_of_servings'] ?? 0,
        calories: info['recipe_calories'] ?? 0,
        difficulty: info['recipe_difficulty'] ?? '',
        videoUrl: info['preparation_video'] ?? '',
        ingredients: parsedIngredients,
        procedures: parsedProcedures,
        prepTime:
            '${time['preparation_time']} ${time['preparation_time_unit']}',
        cookTime: '${time['cook_time']}${time['cook_time_unit']}',
        featuredImage: imageUrl,
        author: json['author']);
  }
}
