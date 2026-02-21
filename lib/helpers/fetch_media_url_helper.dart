import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:recipe_book/constants/api.dart';

/// Fetch a reasonably sized media URL for the given attachment ID.
///
/// Prefers smaller, optimized sizes over the original to reduce download size:
/// - medium
/// - medium_large
/// - large
/// Falls back to the original `source_url` if needed.
Future<String?> fetchMediaUrl(int id) async {
  try {
    final response = await http.get(
      Uri.parse('${ApiEndpoints.media}/$id'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final details = data['media_details'];
      final sizes = details is Map<String, dynamic> ? details['sizes'] : null;

      String? pickSize(Map<String, dynamic> sizeMap, List<String> keys) {
        for (final key in keys) {
          final entry = sizeMap[key];
          if (entry is Map<String, dynamic>) {
            final url = entry['source_url']?.toString();
            if (url != null && url.isNotEmpty) return url;
          }
        }
        return null;
      }

      String? url;
      if (sizes is Map<String, dynamic>) {
        url = pickSize(
          sizes,
          const ['medium', 'medium_large', 'large', 'thumbnail'],
        );
      }

      url ??= data['source_url']?.toString();
      return url;
    }
  } catch (e) {
    log('Error fetching image for ID $id: $e');
  }
  return null;
}
