import 'package:recipe_book/models/user.dart';
import 'package:recipe_book/services/user_service.dart';

final Map<int, User> userCache = {};

Future<User> getUser(int userId) async {
  if (userCache.containsKey(userId)) {
    return userCache[userId]!;
  }

  final user = await UserService.fetchUser(userId);
  if (user != null) {
    userCache[userId] = user;
    return user;
  }

  // Return a fallback User object if fetching fails
  return User(
    id: userId,
    name: 'Unknown',
    imageUrl: '',
  );
}
