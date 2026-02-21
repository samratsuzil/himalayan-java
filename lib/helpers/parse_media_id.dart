/// Parses a media/image ID from API payload.
/// ACF can return: int, numeric string, or object like { "id": 123, "ID": 123 }.
int? parseMediaId(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  if (value is Map) {
    final id = value['id'] ?? value['ID'];
    if (id is int) return id;
    if (id is String) return int.tryParse(id);
  }
  return null;
}
