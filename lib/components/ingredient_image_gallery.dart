import 'package:flutter/material.dart';
import 'package:recipe_book/helpers/fetch_media_url_helper.dart';
import 'package:recipe_book/models/ingredient_item.dart';

class IngredientImageGallery extends StatefulWidget {
  final List<IngredientItem> ingredients;
  final int startIndex;

  const IngredientImageGallery({
    super.key,
    required this.ingredients,
    required this.startIndex,
  });

  @override
  State<IngredientImageGallery> createState() => _IngredientImageGalleryState();
}

class _IngredientImageGalleryState extends State<IngredientImageGallery> {
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.startIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withAlpha(255), // 50% transparent background
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.ingredients.length,
            itemBuilder: (context, index) {
              final ingredient = widget.ingredients[index];

              return FutureBuilder<String?>(
                future: ingredient.image != null
                    ? fetchMediaUrl(ingredient.image!)
                    : Future.value(null),
                builder: (context, snapshot) {
                  final imageUrl = snapshot.data;

                  return GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Center(
                            child: imageUrl != null
                                ? FadeInImage.assetNetwork(
                                    placeholder:
                                        'assets/images/placeholder.jpg',
                                    image: imageUrl,
                                    fit: BoxFit.contain,
                                    placeholderFit: BoxFit.contain,
                                    imageErrorBuilder: (_, __, ___) => Opacity(
                                      opacity: 0.3,
                                      child: Image.asset(
                                        'assets/images/placeholder.jpg',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  )
                                : Opacity(
                                    opacity: 0.3,
                                    child: Image.asset(
                                      'assets/images/placeholder.jpg',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ListTile(
                              tileColor: Colors.black,
                              leading: CircleAvatar(
                                backgroundColor: Colors.teal[50],
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              title: Text(
                                '${ingredient.quantity} ${ingredient.unit} ${ingredient.name}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
