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
    int ingredientIndex = 1;

    List<Widget> ingredientWidgets = [];
    List<Widget> procedureWidgets = [];

    for (final group in recipe.ingredients) {
      if (group is IngredientGroup) {
        ingredientWidgets.add(const SizedBox(height: 8));
        ingredientWidgets.add(
          Text(
            group.groupName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        );

        for (final item in group.items) {
          ingredientWidgets.add(
            IngredientTile(ingredient: item, index: ingredientIndex++),
          );
        }
      } else if (group is IngredientItem) {
        ingredientWidgets.add(
          IngredientTile(ingredient: group, index: ingredientIndex++),
        );
      }
    }

    for (final group in recipe.procedures) {
      if (group is ProcedureGroup) {
        procedureWidgets.add(const SizedBox(height: 8));
        procedureWidgets.add(
          Text(
            group.groupName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        );

        for (final step in group.steps) {
          procedureWidgets.add(
            ProcedureTile(procedure: step, index: stepIndex++),
          );
        }
      } else if (group is ProcedureStep) {
        procedureWidgets.add(
          ProcedureTile(procedure: group, index: stepIndex++),
        );
      }
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            recipe.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
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
                    const SizedBox(height: 16),
                    const TabBar(
                      labelColor: Colors.black,
                      indicatorColor: Colors.orange,
                      tabs: [
                        Tab(text: 'Ingredients'),
                        Tab(text: 'Procedures'),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: TabBarView(
                        children: [
                          // Ingredients Tab
                          SingleChildScrollView(
                            padding: const EdgeInsets.only(top: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Ingredients',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: ingredientWidgets,
                                ),
                              ],
                            ),
                          ),

                          // Procedures Tab
                          SingleChildScrollView(
                            padding: const EdgeInsets.only(top: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Procedures',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: procedureWidgets,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
