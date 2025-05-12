import 'package:flutter/material.dart';
import 'package:recipe_book/components/procedure_image_gallery.dart';
import 'package:recipe_book/models/models.dart';
import 'package:recipe_book/helpers/fetch_media_url_helper.dart';

class ProcedureTile extends StatelessWidget {
  final ProcedureStep procedure;
  final int index;
  final List<ProcedureStep> allProcedures;

  const ProcedureTile({
    super.key,
    required this.procedure,
    required this.index,
    required this.allProcedures,
  });

  void _showFullImage(
      BuildContext context, List<ProcedureStep> procedures, int startIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProcedureImageGallery(
          procedures: procedures,
          startIndex: startIndex,
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

        final imageWidget = ClipRRect(
          borderRadius: BorderRadius.circular(4),
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
        );

        return GestureDetector(
          onTap: () => _showFullImage(context, allProcedures, index - 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // keeps alignment steady
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
          ),
        );
      },
    );
  }
}
