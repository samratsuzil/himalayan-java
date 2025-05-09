import 'package:flutter/material.dart';
import 'package:recipe_book/models/models.dart';
import 'package:recipe_book/helpers/fetch_media_url_helper.dart';

class ProcedureTile extends StatelessWidget {
  final ProcedureStep procedure;
  final int index;

  const ProcedureTile({
    super.key,
    required this.procedure,
    required this.index,
  });

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
      future: procedure.image != null
          ? fetchMediaUrl(procedure.image!)
          : Future.value(null),
      builder: (context, snapshot) {
        final imageUrl = snapshot.data;
        final hasImage = imageUrl != null && imageUrl.isNotEmpty;

        final imageWidget = GestureDetector(
          onTap: () {
            if (hasImage) _showFullImage(context, imageUrl);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: hasImage
                ? Image.network(
                    imageUrl,
                    height: 40,
                    width: 80,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/images/placeholder.jpg',
                    height: 40,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
          ),
        );

        return Padding(
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
                  procedure.description ?? '',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(width: 12),
              imageWidget,
            ],
          ),
        );
      },
    );
  }
}
