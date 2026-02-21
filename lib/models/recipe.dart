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
      if (ingredient is! Map<String, dynamic>) continue;
      if (ingredient.containsKey('sub_ingredients')) {
        parsedIngredients.add(IngredientGroup.fromJson(ingredient));
      } else {
        final single = ingredient['ingredient'];
        if (single is Map<String, dynamic>) {
          parsedIngredients.add(IngredientItem.fromJson(single));
        }
      }
    }

    List<dynamic> parsedProcedures = [];
    for (var procedure in proceduresJson) {
      if (procedure is! Map<String, dynamic>) continue;
      if (procedure.containsKey('sub_procedure')) {
        parsedProcedures.add(ProcedureGroup.fromJson(procedure));
      } else {
        final single = procedure['procedure'];
        if (single is Map<String, dynamic>) {
          parsedProcedures.add(ProcedureStep.fromJson(single));
        }
      }
    }

    final titleObj = json['title'];
    final titleStr = titleObj is Map ? (titleObj['rendered'] ?? '') : '';
    final authorVal = json['author'];
    final authorId = authorVal is int
        ? authorVal
        : (int.tryParse(authorVal?.toString() ?? '') ?? 0);

    return Recipe(
        name: HtmlUnescape().convert(titleStr),
        servings: (info['number_of_servings'] ?? 0) is int
            ? (info['number_of_servings'] as int)
            : (int.tryParse((info['number_of_servings'] ?? 0).toString()) ?? 0),
        calories: (info['recipe_calories'] ?? 0) is int
            ? (info['recipe_calories'] as int)
            : (int.tryParse((info['recipe_calories'] ?? 0).toString()) ?? 0),
        difficulty: info['recipe_difficulty']?.toString() ?? '',
        videoUrl: info['preparation_video']?.toString() ?? '',
        ingredients: parsedIngredients,
        procedures: parsedProcedures,
        prepTime:
            '${time['preparation_time'] ?? ''} ${time['preparation_time_unit'] ?? ''}',
        cookTime: '${time['cook_time'] ?? ''}${time['cook_time_unit'] ?? ''}',
        featuredImage: imageUrl,
        author: authorId);
  }
}
