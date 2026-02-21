import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:recipe_book/components/recipe__meta_info.dart';
import 'package:recipe_book/models/models.dart';
import 'package:recipe_book/components/ingredient_tile.dart';
import 'package:recipe_book/components/procedure_tile.dart';

class RecipeDetailPage extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  late List<Widget> ingredientWidgets;
  late List<Widget> procedureWidgets;

  @override
  void initState() {
    super.initState();
    _buildIngredientWidgets();
    _buildProcedureWidgets();
  }

  List<IngredientItem> getFlatIngredientList(List<dynamic> ingredients) {
    final List<IngredientItem> flatList = [];
    for (final item in ingredients) {
      if (item is IngredientItem) {
        flatList.add(item);
      } else if (item is IngredientGroup) {
        flatList.addAll(item.items);
      }
    }
    return flatList;
  }

  List<ProcedureStep> getFlatProceduresList(List<dynamic> procedures) {
    final List<ProcedureStep> flatList = [];
    for (final procedure in procedures) {
      if (procedure is ProcedureStep) {
        flatList.add(procedure);
      } else if (procedure is ProcedureGroup) {
        flatList.addAll(procedure.steps);
      }
    }
    return flatList;
  }

  void _buildIngredientWidgets() {
    int ingredientIndex = 1;
    ingredientWidgets = [];

    for (final group in widget.recipe.ingredients) {
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
            IngredientTile(
              ingredient: item,
              index: ingredientIndex++,
              allIngredients: getFlatIngredientList(widget.recipe.ingredients),
            ),
          );
        }
      } else if (group is IngredientItem) {
        ingredientWidgets.add(
          IngredientTile(
            ingredient: group,
            index: ingredientIndex++,
            allIngredients: getFlatIngredientList(widget.recipe.ingredients),
          ),
        );
      }
    }
  }

  void _buildProcedureWidgets() {
    int stepIndex = 1;
    procedureWidgets = [];

    for (final group in widget.recipe.procedures) {
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
            ProcedureTile(
              procedure: step,
              index: stepIndex++,
              allProcedures: getFlatProceduresList(widget.recipe.procedures),
            ),
          );
        }
      } else if (group is ProcedureStep) {
        procedureWidgets.add(
          ProcedureTile(
            procedure: group,
            index: stepIndex++,
            allProcedures: getFlatProceduresList(widget.recipe.procedures),
          ),
        );
      }
    }
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _buildIngredientWidgets();
      _buildProcedureWidgets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.recipe.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: (widget.recipe.featuredImage == null ||
                          widget.recipe.featuredImage!.isEmpty)
                      ? Image.asset(
                          'assets/images/placeholder.jpg',
                          fit: BoxFit.cover,
                          height: 200,
                          width: double.infinity,
                        )
                      : CachedNetworkImage(
                          imageUrl: widget.recipe.featuredImage!,
                          fit: BoxFit.cover,
                          height: 200,
                          width: double.infinity,
                          placeholder: (_, __) => Image.asset(
                            'assets/images/placeholder.jpg',
                            fit: BoxFit.cover,
                            height: 200,
                            width: double.infinity,
                          ),
                          errorWidget: (_, __, ___) => Image.asset(
                            'assets/images/placeholder.jpg',
                            fit: BoxFit.cover,
                            height: 200,
                            width: double.infinity,
                          ),
                        ),
                ),
                const SizedBox(height: 16),
                RecipeMetaInfo(
                  authorId: widget.recipe.author,
                  calories: widget.recipe.calories,
                  difficulty: widget.recipe.difficulty,
                  prepTime: widget.recipe.prepTime,
                  cookTime: widget.recipe.cookTime,
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
      ),
    );
  }
}
