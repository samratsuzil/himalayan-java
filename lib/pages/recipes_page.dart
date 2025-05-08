import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:recipe_book/components/recipe_card.dart';
import 'package:recipe_book/components/skeletons/recipe_card_skeleton.dart';
import 'package:recipe_book/components/skeletons/category_chip_skeleton.dart';
import 'package:recipe_book/models/models.dart';
import 'package:recipe_book/pages/recipe_detail_page.dart';
import 'package:recipe_book/services/user_service.dart';
import 'package:recipe_book/services/category_service.dart';
import 'package:recipe_book/services/recipe_service.dart';
import 'package:recipe_book/widgets/recipe_search_delegate.dart';

class RecipesPage extends StatefulWidget {
  final int? authorId;

  const RecipesPage({super.key, this.authorId});

  @override
  RecipesPageState createState() => RecipesPageState();
}

class RecipesPageState extends State<RecipesPage> {
  List<Category> categories = [];
  List<Recipe> recipes = [];
  bool isCategoryLoading = true;
  bool isRecipeLoading = true;
  String searchQuery = "";
  int? selectedCategoryId;
  String? authorName;
  int? localAuthorId; // Local variable to manage the authorId

  @override
  void initState() {
    super.initState();
    localAuthorId =
        widget.authorId; // Initialize localAuthorId with widget.authorId
    fetchCategories();
    fetchRecipes(authorId: localAuthorId);
    if (localAuthorId != null) {
      fetchAuthorName(localAuthorId!);
    }
  }

  Future<void> fetchAuthorName(int authorId) async {
    try {
      final name = await UserService.fetchUserName(
          authorId); // Implement this method in RecipeService
      setState(() {
        authorName = name;
      });
    } catch (e) {
      log('Error fetching author name: $e');
    }
  }

  Future<void> fetchCategories() async {
    setState(() => isCategoryLoading = true);
    try {
      final fetchedCategories = await CategoryService.fetchCategories();
      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      log('Error fetching categories: $e');
    } finally {
      setState(() => isCategoryLoading = false);
    }
  }

  Future<void> fetchRecipes(
      {String? searchQuery, int? categoryId, int? authorId}) async {
    setState(() => isRecipeLoading = true);
    try {
      final fetchedRecipes = await RecipeService.fetchRecipes(
          searchQuery: searchQuery,
          categoryId: categoryId,
          authorId: authorId ?? localAuthorId); // Use localAuthorId here
      setState(() {
        recipes = fetchedRecipes;
      });
    } catch (e) {
      log('Error fetching recipes: $e');
    } finally {
      setState(() => isRecipeLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    String categoryName = 'All';
    if (selectedCategoryId != null) {
      final selectedCategory = categories.firstWhere(
        (category) => category.id == selectedCategoryId,
        orElse: () => Category(id: 0, name: 'All Categories'),
      );
      categoryName = selectedCategory.name;
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    localAuthorId != null && authorName != null
                        ? "${authorName!}'s Recipes"
                        : 'All Recipes',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24),
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
                        setState(() {
                          searchQuery = result;
                        });
                        fetchRecipes(
                          categoryId: selectedCategoryId,
                          searchQuery: searchQuery,
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Categories',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 12),
              isCategoryLoading
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                            6, (_) => const CategoryChipSkeleton()),
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: const Text('All'),
                              selected: selectedCategoryId == null,
                              selectedColor: Colors.teal[800],
                              backgroundColor: Colors.grey[300],
                              showCheckmark: false,
                              labelStyle: TextStyle(
                                color: selectedCategoryId == null
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                              onSelected: (_) {
                                setState(() {
                                  selectedCategoryId = null;
                                });
                                fetchRecipes(searchQuery: searchQuery);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 3,
                            ),
                          ),
                          ...categories.map((cat) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(cat.name),
                                  showCheckmark: false,
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
                                    setState(() {
                                      selectedCategoryId = cat.id;
                                    });
                                    fetchRecipes(
                                      categoryId: cat.id,
                                      searchQuery: searchQuery,
                                    );
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 3,
                                ),
                              )),
                        ],
                      ),
                    ),
              const SizedBox(height: 24),
              const Text('Recipes',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 12),
              if (searchQuery.isNotEmpty ||
                  selectedCategoryId != null ||
                  authorName != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        if (searchQuery.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Chip(
                              label: Text(searchQuery),
                              deleteIcon: const Icon(Icons.cancel, size: 20),
                              onDeleted: () {
                                setState(() {
                                  searchQuery = '';
                                });
                                fetchRecipes(categoryId: selectedCategoryId);
                              },
                              shape: const StadiumBorder(),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                            ),
                          ),
                        if (selectedCategoryId != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Chip(
                              label: Text(categoryName),
                              deleteIcon: const Icon(Icons.cancel, size: 20),
                              onDeleted: () {
                                setState(() {
                                  selectedCategoryId = null;
                                });
                                fetchRecipes(searchQuery: searchQuery);
                              },
                              shape: const StadiumBorder(),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                            ),
                          ),
                        if (authorName != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Chip(
                              label: Text(authorName.toString()),
                              deleteIcon: const Icon(Icons.cancel, size: 20),
                              onDeleted: () {
                                setState(() {
                                  authorName = null;
                                  localAuthorId = null; // Reset localAuthorId
                                });
                                fetchRecipes(
                                    searchQuery: searchQuery,
                                    categoryId: selectedCategoryId);
                              },
                              shape: const StadiumBorder(),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: RefreshIndicator(
                  onRefresh: () => fetchRecipes(
                    searchQuery: searchQuery,
                    categoryId: selectedCategoryId,
                  ),
                  child: isRecipeLoading
                      ? GridView.builder(
                          itemCount: 6,
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                MediaQuery.of(context).orientation ==
                                        Orientation.portrait
                                    ? 1
                                    : 2,
                            childAspectRatio: 16 / 9,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemBuilder: (_, __) => const RecipeCardSkeleton(),
                        )
                      : recipes.isEmpty
                          ? const Center(
                              child: Text(
                                  "No recipes found. Try another search or category."))
                          : GridView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: recipes.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    MediaQuery.of(context).orientation ==
                                            Orientation.portrait
                                        ? 1
                                        : 2,
                                childAspectRatio: 16 / 9,
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
                                      RecipeCard(
                                          imageUrl: recipe.featuredImage ?? '',
                                          title: recipe.name,
                                          author: recipe.author),
                                    ],
                                  ),
                                );
                              },
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
