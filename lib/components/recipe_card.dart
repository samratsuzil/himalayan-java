import 'package:flutter/material.dart';
import 'package:recipe_book/helpers/author_cache.dart';

class RecipeCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final int? author;
  final String duration;
  final double rating;
  final bool isBookmarked;

  const RecipeCard({
    super.key,
    required this.imageUrl,
    required this.title,
    this.author,
    this.duration = '20 minutes',
    this.rating = 5,
    this.isBookmarked = false,
  });

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  String? authorName;

  @override
  void initState() {
    super.initState();
    _loadAuthorName();
  }

  Future<void> _loadAuthorName() async {
    if (widget.author != null) {
      final name = await getAuthorName(widget.author!);
      if (mounted) {
        setState(() {
          authorName = name ?? 'Unknown';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/placeholder.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withAlpha(160),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    widget.rating.toStringAsFixed(1),
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '- ${authorName ?? "..."}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      widget.duration,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
