import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe.dart';
import 'package:recipe_book/pages/recipe_detail_page.dart';
import 'package:recipe_book/components/food_card.dart';
import 'package:recipe_book/components/suggested_dish.dart';
import 'package:recipe_book/services/recipe_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final categories = ['All', 'Breakfast', 'Lunch', 'Dinner'];
  List<Recipe> recipes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    try {
      final result = await RecipeService.fetchRecipes();
      setState(() {
        recipes = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load recipes: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_view), label: 'Categories'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border), label: 'Save'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
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
                        const CircleAvatar(
                          radius: 24,
                          backgroundImage:
                              NetworkImage('https://i.pravatar.cc/150?img=3'),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Welcome Back!',
                                style: TextStyle(fontSize: 12)),
                            Text('Wilson Dias',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const Spacer(),
                        const Icon(Icons.search),
                        const SizedBox(width: 12),
                        const Icon(Icons.notifications_outlined),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Categories
                    const Text('Categories',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: categories
                          .map((cat) => Chip(
                                label: Text(cat),
                                backgroundColor: cat == 'All'
                                    ? Colors.black
                                    : Colors.grey[200],
                                labelStyle: TextStyle(
                                    color: cat == 'All'
                                        ? Colors.white
                                        : Colors.black),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 24),

                    // Popular Now
                    const Text('Popular Now',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 12),
                    ...recipes.take(2).map((recipe) => GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RecipeDetailPage(recipe: recipe),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: FoodCard(
                              imageUrl: recipe.featuredImage,
                              title: recipe.name,
                              rating: recipe.difficulty,
                            ),
                          ),
                        )),

                    const SizedBox(height: 24),
                    const Text('You May Also Like',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 12),
                    ...recipes.skip(2).map((recipe) => GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RecipeDetailPage(recipe: recipe),
                            ),
                          ),
                          child: SuggestedDish(
                            imageUrl: recipe.featuredImage,
                            title: recipe.name,
                            rating: recipe.difficulty,
                          ),
                        )),
                  ],
                ),
              ),
      ),
    );
  }
}
