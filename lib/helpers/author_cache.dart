import 'package:recipe_book/models/user.dart';

final Map<int, User> _authorCache = {};

Future<User> getUser(int authorId) async {
  if (_authorCache.containsKey(authorId)) {
    return _authorCache[authorId]!;
  }

  final user = await fetchUser(authorId);
  if (user != null) {
    _authorCache[authorId] = user;
    return user;
  }

  // Return a fallback User object if fetching fails
  return User(
    id: authorId,
    name: 'Unknown',
    imageUrl: '',
  );
}
