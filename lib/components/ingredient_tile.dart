import 'package:flutter/material.dart';
import 'package:recipe_book/models/models.dart';
import 'package:recipe_book/helpers/fetch_media_url_helper.dart';

class IngredientTile extends StatelessWidget {
  final IngredientItem ingredient;

  const IngredientTile({super.key, required this.ingredient});

  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        backgroundColor: Colors.black54,
        insetPadding: EdgeInsets.zero,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: InteractiveViewer(
            child: Center(
              child: Image.network(imageUrl),
            ),
          ),
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

        final imageWidget = GestureDetector(
          onTap: () {
            if (hasImage) _showFullImage(context, imageUrl);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: hasImage
                ? Image.network(
                    imageUrl,
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/images/placeholder.jpg',
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  ),
          ),
        );

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          leading: imageWidget,
          title: Text(
            '${ingredient.quantity} ${ingredient.unit} ${ingredient.name}',
            style: const TextStyle(fontSize: 16),
          ),
        );
      },
    );
  }
}
