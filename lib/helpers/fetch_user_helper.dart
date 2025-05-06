import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

Future<String?> fetchUserName(int id) async {
  try {
    final response = await http.get(
      Uri.parse('https://project.astranix.com.np/wp-json/wp/v2/users/$id'),
    );
    log('Fetching user data from: ${response.request?.url}');
    log('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      log('Fetched user data: $data');
      return data['name'];
    }
  } catch (e) {
    log('Error fetching user for ID $id: $e');
  }
  return null;
}
