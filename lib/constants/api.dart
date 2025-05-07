class ApiEndpoints {
  static const String baseUrl = 'https://project.astranix.com.np/wp-json/wp/v2';

  // Endpoints
  static const String recipes = '$baseUrl/recipes/?_embed';
  static const String media = '$baseUrl/media';
  static const String categories = '$baseUrl/categories';

  static const String customAPIbaseUrl = 'https://project.astranix.com.np/v1';
  static const String users = '$customAPIbaseUrl/users';
}
