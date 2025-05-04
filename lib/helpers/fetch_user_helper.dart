import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

Future<String?> fetchUserName(int id) async {
  try {
    final response = await http.get(
      Uri.parse('https://project.astranix.com.np/wp-json/wp/v2/users/$id'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['name'];
    }
  } catch (e) {
    log('Error fetching user for ID $id: $e');
  }
  return null;
}
