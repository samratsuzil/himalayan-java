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
  int? localAuthorId;
  User? author;

  @override
  void initState() {
    super.initState();
    localAuthorId = widget.authorId;
    refreshAll();
    if (localAuthorId != null) {
      fetchAuthor(localAuthorId!);
    }
  }

  Future<void> fetchAuthor(int authorId) async {
    try {
      final fetchedAuthor = await UserService.fetchUser(authorId);
      if (!mounted) return;
      setState(() {
        author = fetchedAuthor;
      });
    } catch (e) {
      log('Error fetching author: $e');
    }
  }

  Future<void> fetchCategories() async {
    if (!mounted) return;
    setState(() => isCategoryLoading = true);
    try {
      final fetchedCategories = await CategoryService.fetchCategories();
      if (!mounted) return;
      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      log('Error fetching categories: $e');
    } finally {
      if (!mounted) return;
      setState(() => isCategoryLoading = false);
    }
  }

  Future<void> fetchRecipes({String? searchQuery, int? categoryId}) async {
    if (!mounted) return;
    setState(() => isRecipeLoading = true);
    try {
      final fetchedRecipes = await RecipeService.fetchRecipes(
        searchQuery: searchQuery,
        categoryId: categoryId,
        authorId: localAuthorId,
      );
      if (!mounted) return;
      setState(() {
        recipes = fetchedRecipes;
      });
    } catch (e) {
      log('Error fetching recipes: $e');
    } finally {
      if (!mounted) return;
      setState(() => isRecipeLoading = false);
    }
  }

  Future<void> refreshAll() async {
    await Future.wait([
      fetchCategories(),
      fetchRecipes(searchQuery: searchQuery, categoryId: selectedCategoryId),
    ]);
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
      appBar: AppBar(
        title: author != null
            ? Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(author!.imageUrl),
                    radius: 24,
                    backgroundColor: Colors.grey[200],
                  ),
                  const SizedBox(width: 8),
                  Text(author!.name),
                ],
              )
            : const Text(
                'Home',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
        backgroundColor: Colors.white,
        leading: ModalRoute.of(context)?.settings.name == '/home'
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final result = await showSearch<String>(
                context: context,
                delegate: RecipeSearchDelegate(),
              );
              if (result != null && result.isNotEmpty) {
                setState(() => searchQuery = result);
                fetchRecipes(
                    categoryId: selectedCategoryId, searchQuery: searchQuery);
              }
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: refreshAll,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Categories',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 12),
              isCategoryLoading
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: List.generate(
                              6, (_) => const CategoryChipSkeleton())),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildChoiceChip(null, 'All'),
                          ...categories
                              .map((cat) => _buildChoiceChip(cat.id, cat.name)),
                        ],
                      ),
                    ),
              const SizedBox(height: 24),
              Text(author != null ? "${author!.name}'s Recipes" : 'All Recipes',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              if (searchQuery.isNotEmpty ||
                  selectedCategoryId != null ||
                  author != null)
                _buildFilterChips(categoryName),
              if (isRecipeLoading)
                _buildLoadingGrid()
              else if (recipes.isEmpty)
                const Text("No recipes found. Try another search or category.")
              else
                _buildRecipeGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceChip(int? id, String name) {
    final isSelected = selectedCategoryId == id;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(name),
        selected: isSelected,
        selectedColor: Colors.teal[800],
        backgroundColor: Colors.grey[300],
        showCheckmark: false,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        onSelected: (_) {
          setState(() => selectedCategoryId = id);
          fetchRecipes(searchQuery: searchQuery, categoryId: id);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 3,
      ),
    );
  }

  Widget _buildFilterChips(String categoryName) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const Text('Filters: ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(width: 8),
            if (searchQuery.isNotEmpty)
              _buildFilterChip("Search: $searchQuery", () {
                setState(() => searchQuery = '');
                fetchRecipes(categoryId: selectedCategoryId);
              }),
            if (selectedCategoryId != null)
              _buildFilterChip("Category: $categoryName", () {
                setState(() => selectedCategoryId = null);
                fetchRecipes(searchQuery: searchQuery);
              }),
            if (author != null)
              _buildFilterChip("Chef: ${author!.name}", () {
                setState(() {
                  author = null;
                  localAuthorId = null;
                });
                fetchRecipes(
                    searchQuery: searchQuery, categoryId: selectedCategoryId);
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onDeleted) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        deleteIcon: const Icon(Icons.cancel, size: 20),
        onDeleted: onDeleted,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            MediaQuery.of(context).orientation == Orientation.portrait ? 1 : 2,
        childAspectRatio: 16 / 9,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (_, __) => const RecipeCardSkeleton(),
    );
  }

  Widget _buildRecipeGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: recipes.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            MediaQuery.of(context).orientation == Orientation.portrait ? 1 : 2,
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
              builder: (context) => RecipeDetailPage(recipe: recipe),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              RecipeCard(
                imageUrl:
                    recipe.featuredImageSmall ?? recipe.featuredImage ?? '',
                title: recipe.name,
                author: recipe.author,
              ),
            ],
          ),
        );
      },
    );
  }
}
