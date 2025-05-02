import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class IngredientItem extends StatefulWidget {
  final String title;
  final String subtitle;
  final int? imageId; // Image ID to fetch
  final bool isSingle; // Flag to check if it's a single ingredient or a group

  const IngredientItem({
    required this.title,
    required this.subtitle,
    this.imageId, // Optional field for image ID
    this.isSingle = false, // Default is false (group)
    super.key,
  });

  @override
  _IngredientItemState createState() => _IngredientItemState();
}

class _IngredientItemState extends State<IngredientItem> {
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.imageId != null) {
      _fetchImageUrl(widget.imageId!);
    }
  }

  Future<void> _fetchImageUrl(int imageId) async {
    final url = Uri.parse(
        'https://project.astranix.com.np/wp-json/wp/v2/media/$imageId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        imageUrl = data['source_url'];
      });
    } else {
      // Handle error or no image case
      setState(() {
        imageUrl = ''; // Use default or empty
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Column(
        children: [
          // Displaying image if URL is available
          if (imageUrl != null && imageUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl!,
                width: 100,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 8),
          Text(widget.title,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(widget.subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 12)),
          if (!widget.isSingle)
            const SizedBox(
                height: 10), // Adds space for list of ingredients if needed
        ],
      ),
    );
  }
}

class IngredientGroup extends StatelessWidget {
  final List<dynamic>
      ingredients; // List of ingredients, either group or single

  const IngredientGroup({required this.ingredients, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: ingredients.map<Widget>((ingredientData) {
        if (ingredientData['acf_fc_layout'] == 'list') {
          // Handle list layout
          var subIngredients = ingredientData['sub_ingredients']['items'];
          return Column(
            children: subIngredients.map<Widget>((subIngredient) {
              return IngredientItem(
                title: subIngredient['name'],
                subtitle:
                    '${subIngredient['quantity']} ${subIngredient['unit']}',
                imageId: subIngredient['image'],
                isSingle: false, // It's part of a list, not single
              );
            }).toList(),
          );
        } else if (ingredientData['acf_fc_layout'] == 'single') {
          // Handle single layout
          var ingredient = ingredientData['ingredient'];
          return IngredientItem(
            title: ingredient['name'],
            subtitle: '${ingredient['quantity']} ${ingredient['unit']}',
            imageId: ingredient['image'],
            isSingle: true, // It's a single ingredient, not part of a list
          );
        }
        return SizedBox.shrink(); // Return an empty widget if layout is unknown
      }).toList(),
    );
  }
}
