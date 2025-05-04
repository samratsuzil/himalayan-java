import 'package:flutter/material.dart';
import 'package:recipe_book/models/models.dart';
import 'package:recipe_book/components/ingredient_tile.dart';
import 'package:recipe_book/components/procedure_tile.dart';

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
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
            Navigator.pop(
                context); // Pops the current page from the navigation stack
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipe Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  recipe.featuredImage ??
                      'assets/placeholder.jpg', // Use placeholder image if no URL
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 16),

              // Ingredients Section
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
                            padding: const EdgeInsets.only(left: 16),
                            child: IngredientTile(ingredient: ingredient),
                          )),
                    ],
                  )
                else if (group is IngredientItem)
                  IngredientTile(ingredient: group),

              SizedBox(height: 16),

              // Procedures Section
              const Text(
                'Procedures',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              for (var group in recipe.procedures)
                if (group is ProcedureGroup)
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
                      ...group.steps.map((step) => Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: ProcedureTile(procedure: step),
                          )),
                    ],
                  )
                else if (group is ProcedureStep)
                  ProcedureTile(procedure: group),
            ],
          ),
        ),
      ),
    );
  }
}
