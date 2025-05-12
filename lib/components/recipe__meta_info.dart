import 'package:flutter/material.dart';
import 'package:recipe_book/helpers/user_cache.dart';
import 'package:recipe_book/models/user.dart';
import 'package:recipe_book/pages/recipes_page.dart'; // your User model

class RecipeMetaInfo extends StatelessWidget {
  final int authorId;
  final int calories;
  final String difficulty;
  final String? prepTime;
  final String? cookTime;

  const RecipeMetaInfo({
    super.key,
    required this.authorId,
    required this.calories,
    required this.difficulty,
    this.prepTime,
    this.cookTime,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: getUser(authorId),
      builder: (context, snapshot) {
        final user = snapshot.data;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user != null)
              Row(
                children: [
                  Text('By ',
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.black)),

                  CircleAvatar(
                    backgroundImage: NetworkImage(user.imageUrl),
                    radius: 16,
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => RecipesPage(
                                      authorId: authorId,
                                    )));
                      },
                      child: Text(user.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black))),

                  // Spacer(),
                ],
              ),
            const SizedBox(height: 12),
            SizedBox(
                height: 140, // Adjust based on tile size
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 3, // Adjust to control tile height
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: [
                    _buildInfoTile('🔥 Calories', '$calories kcal'),
                    _buildInfoTile('🧩 Difficulty', difficulty),
                    _buildInfoTile('⏱ Preparation', prepTime.toString()),
                    _buildInfoTile('🍳 Cooking', cookTime.toString()),
                  ],
                )),
          ],
        );
      },
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.teal[50], // Red background
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: Colors.teal, width: 1), // Border color and width
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 14, color: Colors.black)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        )
      ],
    );
  }
}
