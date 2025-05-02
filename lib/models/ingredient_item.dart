class IngredientItem {
  final String name;
  final String unit;
  final double quantity;
  final double image;

  IngredientItem({
    required this.name,
    required this.unit,
    required this.quantity,
    required this.image,
  });

  factory IngredientItem.fromJson(Map<String, dynamic> json) {
    return IngredientItem(
      name: json['name'] ?? '',
      unit: json['unit'] ?? '',
      image: json['imageId'] ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'image': image,
    };
  }
}
