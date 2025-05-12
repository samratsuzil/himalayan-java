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
  List<String?> _imageUrls = [];
  bool _isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.startIndex);
    _currentIndex = widget.startIndex;
    _fetchAllImageUrls();
  }

  Future<void> _fetchAllImageUrls() async {
    final results = await Future.wait(
      widget.ingredients.map((ingredient) async {
        if (ingredient.image != null) {
          return await fetchMediaUrl(ingredient.image!);
        } else {
          return null;
        }
      }),
    );

    setState(() {
      _imageUrls = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // Background image with blur or dark overlay
                Positioned.fill(
                  child: _imageUrls[_currentIndex] != null &&
                          _imageUrls[_currentIndex]!.isNotEmpty
                      ? Image.network(
                          _imageUrls[_currentIndex]!,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/placeholder.jpg',
                          fit: BoxFit.cover,
                        ),
                ),
                // Optional: add dark overlay
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withAlpha(200),
                  ),
                ),
                // Main content
                Column(
                  children: [
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close,
                              color: Colors.white, size: 28),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Ingredient',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        CircleAvatar(
                          backgroundColor: Colors.teal[50],
                          child: Text(
                            '${_currentIndex + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: PageView.builder(
                        controller: _controller,
                        itemCount: widget.ingredients.length,
                        onPageChanged: (index) =>
                            setState(() => _currentIndex = index),
                        itemBuilder: (context, index) {
                          final ingredient = widget.ingredients[index];
                          final imageUrl = _imageUrls[index];

                          return Column(
                            children: [
                              SizedBox(
                                height: height / 3,
                                width: double.infinity,
                                child: imageUrl != null && imageUrl.isNotEmpty
                                    ? Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'assets/images/placeholder.jpg',
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 12),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: Text(
                                            '${ingredient.quantity} ${ingredient.unit} ${ingredient.name}',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
