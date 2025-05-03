import 'package:flutter/material.dart';
import 'package:recipe_book/components/food_card.dart';
import 'package:recipe_book/models/recipe.dart';
import 'package:recipe_book/models/category.dart';
import 'package:recipe_book/pages/recipe_detail_page.dart';
import 'package:recipe_book/services/category_service.dart';
import 'package:recipe_book/services/recipe_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Category> categories = [];
  List<Recipe> recipes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    try {
      final fetchedCategories = await CategoryService.fetchCategories();
      final fetchedRecipes = await RecipeService.fetchRecipes();

      setState(() {
        categories = fetchedCategories;
        recipes = fetchedRecipes;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Section
                    Row(
                      children: [
                        const Text('Recipe Book',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            )),
                        const Spacer(),
                        const Icon(Icons.search),
                        const SizedBox(width: 12)
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Categories Section
                    const Text('Categories',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: categories
                            .map((cat) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Chip(
                                    label: Text(cat.name),
                                    backgroundColor: Colors.red[400],
                                    labelStyle: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Grid of Recipes
                    const Text('Recipes',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 12),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        return ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: constraints.maxHeight,
                          ),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: recipes.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  MediaQuery.of(context).orientation ==
                                          Orientation.portrait
                                      ? 2
                                      : 4,
                              childAspectRatio: 0.9,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemBuilder: (context, index) {
                              final recipe = recipes[index];
                              return GestureDetector(
                                  onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RecipeDetailPage(recipe: recipe),
                                        ),
                                      ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      FoodCard(
                                        imageUrl: recipe.featuredImage ?? '',
                                        title: recipe.name,
                                        rating: recipe.difficulty,
                                      ),
                                    ],
                                  ));
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
