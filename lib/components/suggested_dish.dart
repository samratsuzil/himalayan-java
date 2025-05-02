import 'package:flutter/material.dart';

class SuggestedDish extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String rating;

  const SuggestedDish(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.rating});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl ?? '',
          width: 64,
          height: 64,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            'assets/placeholder.jpg',
            width: 64,
            height: 64,
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 16),
          Text(rating),
        ],
      ),
    );
  }
}
