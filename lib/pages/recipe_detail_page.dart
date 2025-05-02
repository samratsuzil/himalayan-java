import 'package:flutter/material.dart';
import 'package:recipe_book/components/json_viewer.dart';
import 'package:recipe_book/models/models.dart';
import 'dart:convert';

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
        backgroundColor: Colors.black,
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

              // Recipe Name and Author
              Text(
                recipe.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Ingredients
              const Text('Ingredients',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              JsonViewer(
                jsonData: {
                  "ingredients": recipe.ingredients
                      .map((group) => group.toJson())
                      .toList(),
                },
              ),
              const SizedBox(height: 8),

              for (var ingredientGroup in recipe.ingredients)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ingredientGroup.groupName,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    for (var ingredient in ingredientGroup.items)
                      Text(
                          '${ingredient.quantity} ${ingredient.unit} ${ingredient.name}'),
                    const SizedBox(height: 16),
                  ],
                ),

              // Procedures
              const Text('Procedures',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              for (var procedureGroup in recipe.procedures)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(procedureGroup.groupName,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    for (var procedure in procedureGroup.steps)
                      Text(procedure.description),
                    const SizedBox(height: 16),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
