import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

Future<String?> fetchImageUrl(int id) async {
  try {
    final response = await http.get(
      Uri.parse('https://project.astranix.com.np/wp-json/wp/v2/media/$id'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['source_url'];
    }
  } catch (e) {
    log('Error fetching image for ID $id: $e');
  }
  return null;
}
