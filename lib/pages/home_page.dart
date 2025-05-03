import 'package:flutter/material.dart';
import 'package:recipe_book/components/food_card.dart';
import 'package:recipe_book/models/recipe.dart';
import 'package:recipe_book/models/category.dart';
import 'package:recipe_book/pages/recipe_detail_page.dart';
import 'package:recipe_book/services/category_service.dart';
import 'package:recipe_book/services/recipe_service.dart';
import 'package:recipe_book/widgets/recipe_search_delegate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Category> categories = [];
  List<Recipe> recipes = [];
  bool isCategoryLoading = true;
  bool isRecipeLoading = true;
  String searchQuery = "";
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchRecipes();
  }

  Future<void> fetchCategories() async {
    setState(() => isCategoryLoading = true);
    try {
      final fetchedCategories = await CategoryService.fetchCategories();
      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      print('Error fetching categories: $e');
    } finally {
      setState(() => isCategoryLoading = false);
    }
  }

  Future<void> fetchRecipes({String? searchQuery, int? categoryId}) async {
    setState(() => isRecipeLoading = true);
    try {
      final fetchedRecipes = await RecipeService.fetchRecipes(
        searchQuery: searchQuery,
        categoryId: categoryId,
      );
      setState(() {
        recipes = fetchedRecipes;
      });
    } catch (e) {
      print('Error fetching recipes: $e');
    } finally {
      setState(() => isRecipeLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                children: [
                  const Text(
                    'Recipe Book',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () async {
                      final result = await showSearch<String>(
                        context: context,
                        delegate: RecipeSearchDelegate(),
                      );
                      if (result != null && result.isNotEmpty) {
                        Future.delayed(Duration.zero, () {
                          setState(() {
                            searchQuery = result;
                          });
                          fetchRecipes(
                            categoryId: selectedCategoryId,
                            searchQuery: searchQuery,
                          );
                        });
                      }
                    },
                  ),
                  const SizedBox(width: 12),
                ],
              ),

              const SizedBox(height: 24),

              // Categories Section
              const Text('Categories',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 12),
              isCategoryLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // "All" Chip
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: const Text('All'),
                              checkmarkColor:
                                  Colors.white, // 👈 white tick icon

                              selected: selectedCategoryId == null,
                              selectedColor: Colors.teal[800],
                              backgroundColor: Colors.grey[300],
                              labelStyle: TextStyle(
                                color: selectedCategoryId == null
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                              onSelected: (_) {
                                setState(() => selectedCategoryId = null);
                                fetchRecipes(searchQuery: searchQuery);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 3,
                              pressElevation: 6,
                            ),
                          ),
                          ...categories.map(
                            (cat) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(cat.name),
                                checkmarkColor:
                                    Colors.white, // 👈 white tick icon
                                selected: selectedCategoryId == cat.id,
                                selectedColor: Colors.teal[800],
                                backgroundColor: Colors.grey[300],
                                labelStyle: TextStyle(
                                  color: selectedCategoryId == cat.id
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                                onSelected: (_) {
                                  setState(() => selectedCategoryId = cat.id);
                                  fetchRecipes(
                                    categoryId: cat.id,
                                    searchQuery: searchQuery,
                                  );
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 3,
                                pressElevation: 6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              const SizedBox(height: 24),

              // Clear Search Button
              if (searchQuery.isNotEmpty) ...[
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() => searchQuery = '');
                        fetchRecipes(categoryId: selectedCategoryId);
                      },
                      icon: const Icon(Icons.close),
                      label: Text('Clear Search "$searchQuery"'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],

              // Recipes Section
              const Text('Recipes',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 12),

              if (isRecipeLoading)
                const Center(child: CircularProgressIndicator())
              else if (recipes.isEmpty)
                const Center(
                    child: Text(
                        "No recipes found. Try another search or category."))
              else
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
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: MediaQuery.of(context).orientation ==
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
                                ),
                              ],
                            ),
                          );
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
