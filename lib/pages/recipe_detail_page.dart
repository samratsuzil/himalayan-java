import 'package:flutter/material.dart';
import 'package:recipe_book/components/recipe__meta_info.dart';
import 'package:recipe_book/models/models.dart';
import 'package:recipe_book/components/ingredient_tile.dart';
import 'package:recipe_book/components/procedure_tile.dart';

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    int stepIndex = 1;
    List<Widget> procedureWidgets = [];

    for (int i = 0; i < recipe.procedures.length; i++) {
      final group = recipe.procedures[i];

      if (group is ProcedureGroup) {
        procedureWidgets.add(const SizedBox(height: 8));
        procedureWidgets.add(
          Text(
            group.groupName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        );

        for (int j = 0; j < group.steps.length; j++) {
          procedureWidgets.add(
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child:
                  ProcedureTile(procedure: group.steps[j], index: stepIndex++),
            ),
          );
        }
      } else if (group is ProcedureStep) {
        procedureWidgets.add(
          ProcedureTile(procedure: group, index: stepIndex++),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  recipe.featuredImage ?? 'assets/placeholder.jpg',
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 16),
              RecipeMetaInfo(
                authorId: recipe.author,
                calories: recipe.calories,
                difficulty: recipe.difficulty,
                prepTime: recipe.prepTime,
                cookTime: recipe.cookTime,
              ),
              const Text(
                'Ingredients',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              for (var group in recipe.ingredients)
                if (group is IngredientGroup)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Text(
                        group.groupName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      ...group.items.map((ingredient) => Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: IngredientTile(ingredient: ingredient),
                          )),
                    ],
                  )
                else if (group is IngredientItem)
                  IngredientTile(ingredient: group),
              SizedBox(height: 16),
              const Text(
                'Procedures',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // for (var group in recipe.procedures)
              //   if (group is ProcedureGroup)
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         SizedBox(height: 8),
              //         Text(
              //           group.groupName,
              //           style: const TextStyle(
              //             fontWeight: FontWeight.bold,
              //             fontSize: 16,
              //           ),
              //         ),
              //         ...group.steps.map((step) => Padding(
              //               padding: const EdgeInsets.only(left: 16),
              //               child: ProcedureTile(procedure: step),
              //             )),
              //       ],
              //     )
              //   else if (group is ProcedureStep)
              //     ProcedureTile(procedure: group),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: procedureWidgets,
              )
            ],
          ),
        ),
      ),
    );
  }
}
