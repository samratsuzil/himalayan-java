import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:recipe_book/constants/api.dart';
import 'package:recipe_book/models/models.dart';

class UserService {
  static Future<List<User>> fetchUsers({String? searchQuery}) async {
    String url = ApiEndpoints.users;

    if (searchQuery != null && searchQuery.isNotEmpty) {
      url += '?search=$searchQuery';
    }

    log('Fetching authors from: $url');

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((item) => User.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  }

  static Future<String> fetchUserName(int authorId) async {
    final url = Uri.parse('${ApiEndpoints.users}/$authorId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['name'] ?? 'Unknown';
    } else {
      throw Exception('Failed to load author name');
    }
  }

  // Update the fetch function to return User
  static Future<User?> fetchUser(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiEndpoints.users}/$id'),
      );
      log('Fetching user data from: ${response.request?.url}');
      log('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      }
    } catch (e) {
      log('Error fetching user for ID $id: $e');
    }
    return null;
  }
}
