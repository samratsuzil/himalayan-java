import 'ingredient_item.dart';

class IngredientGroup {
  final String groupName;
  final List<IngredientItem> items;

  IngredientGroup({
    required this.groupName,
    required this.items,
  });

 Map<String, dynamic> toJson() {
    return {
      'groupName': groupName,
      'items': items.map((ingredient) => ingredient.toJson()).toList(),
    };
  }
  
  factory IngredientGroup.fromJson(Map<String, dynamic> json) {
    final sub = json['sub_ingredients'] ?? {};
    final itemsJson = sub['items'] ?? [];
    return IngredientGroup(
      groupName: sub['name'] ?? '',
      items: List<Map<String, dynamic>>.from(itemsJson)
          .map((e) => IngredientItem.fromJson(e))
          .toList(),
    );
  }
}
