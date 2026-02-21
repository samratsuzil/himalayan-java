import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:recipe_book/components/ingredient_image_gallery.dart';
import 'package:recipe_book/models/models.dart';
import 'package:recipe_book/helpers/fetch_media_url_helper.dart';

class IngredientTile extends StatelessWidget {
  final IngredientItem ingredient;
  final int index;
  final List<IngredientItem> allIngredients;

  const IngredientTile(
      {super.key,
      required this.ingredient,
      required this.index,
      required this.allIngredients});

  void _showFullImage(
      BuildContext context, List<IngredientItem> ingredients, int startIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => IngredientImageGallery(
          ingredients: allIngredients,
          startIndex: startIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: ingredient.image != null
          ? fetchMediaUrl(ingredient.image!)
          : Future.value(null),
      builder: (context, snapshot) {
        final imageUrl = snapshot.data;
        final hasImage = imageUrl != null && imageUrl.isNotEmpty;

        final imageWidget = ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: hasImage
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  height: 40,
                  width: 80,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Image.asset(
                    'assets/images/placeholder.jpg',
                    height: 40,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/placeholder.jpg',
                    height: 40,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                  memCacheWidth: 160,
                )
              : Image.asset(
                  'assets/images/placeholder.jpg',
                  height: 40,
                  width: 80,
                  fit: BoxFit.cover,
                ),
        );

        return GestureDetector(
          onTap: () {
            _showFullImage(context, allIngredients, index - 1);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.teal[50],
                  child: Text(
                    '$index',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${ingredient.quantity} ${ingredient.unit} ${ingredient.name}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(width: 12),
                imageWidget,
              ],
            ),
          ),
        );
      },
    );
  }
}
