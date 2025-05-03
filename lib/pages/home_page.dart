import 'package:flutter/material.dart';
import 'package:recipe_book/components/food_card.dart';
import 'package:recipe_book/models/recipe.dart';
import 'package:recipe_book/models/category.dart';
import 'package:recipe_book/pages/recipe_detail_page.dart';
import 'package:recipe_book/services/category_service.dart';
import 'package:recipe_book/services/recipe_service.dart';
import 'package:recipe_book/widgets/recipe_search_delegate.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Category> categories = [];
  List<Recipe> recipes = [];
  bool isLoading = true;
  String searchQuery = ""; // Track the search query
  int? selectedCategoryId; // Track the selected category

  @override
  void initState() {
    super.initState();
    fetchCategories(); // Fetch categories
    fetchRecipes(); // Fetch recipes on load
  }

  Future<void> fetchCategories() async {
    try {
      final fetchedCategories = await CategoryService.fetchCategories();
      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      // Handle error gracefully
      print('Error fetching categories: $e');
    }
  }

  Future<void> fetchRecipes({String? searchQuery, int? categoryId}) async {
    setState(() => isLoading = true);

    try {
      final fetchedRecipes = await RecipeService.fetchRecipes(
        searchQuery: searchQuery,
        categoryId: selectedCategoryId,
      );
      setState(() {
        recipes = fetchedRecipes;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      // handle error (show a snackbar maybe)
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
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () async {
                            // Trigger the search
                            final result = await showSearch<String>(
                              context: context,
                              delegate: RecipeSearchDelegate(),
                            );
                            // Update the search query after search closes
                            if (result != null && result.isNotEmpty) {
                              // Delay setState until after the search delegate closes
                              Future.delayed(Duration.zero, () {
                                setState(() {
                                  searchQuery = result;
                                  isLoading = true; // Show loading
                                });
                                // Fetch the recipes based on the new search query
                                fetchRecipes(
                                    categoryId: selectedCategoryId,
                                    searchQuery: searchQuery);
                              });
                            }
                          },
                        ),
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
                                  child: GestureDetector(
                                    onTap: () {
                                      // Fetch recipes by category when tapped
                                      setState(() {
                                        selectedCategoryId =
                                            cat.id; // Update selected category
                                      });
                                      fetchRecipes(
                                          categoryId: cat.id,
                                          searchQuery: searchQuery);
                                    },
                                    child: Chip(
                                      label: Text(cat.name),
                                      backgroundColor:
                                          selectedCategoryId == cat.id
                                              ? Colors.teal[900]
                                              : Colors.red[900],
                                      labelStyle: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),

                    const SizedBox(height: 24),

                    if (searchQuery.isNotEmpty) ...[
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            child: Row(
                              children: [
                                Text('Clear Search $searchQuery'),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        searchQuery = ''; // Clear search query
                                        fetchRecipes(
                                            categoryId: selectedCategoryId,
                                            searchQuery:
                                                ''); // Fetch all recipes again
                                      });
                                    },
                                    icon: Icon(Icons.close))
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                    // Grid of Recipes
                    const Text('Recipes',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 12),

                    // Display the list of recipes
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
                                        // rating: recipe.difficulty,
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
