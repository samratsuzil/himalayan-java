import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:recipe_book/constants/api.dart';

Future<String?> fetchMediaUrl(int id) async {
  try {
    final response = await http.get(
      Uri.parse('${ApiEndpoints.media}/$id'),
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
