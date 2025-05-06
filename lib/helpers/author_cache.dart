import 'package:recipe_book/helpers/fetch_user_helper.dart';

final Map<int, String> _authorCache = {};

Future<String> getAuthorName(int authorId) async {
  if (_authorCache.containsKey(authorId)) {
    return _authorCache[authorId]!;
  }

  final name = await fetchUserName(authorId) ?? 'Unknown';
  _authorCache[authorId] = name;
  return name;
}
