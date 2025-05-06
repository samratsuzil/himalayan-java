class IngredientItem {
  final String name;
  final String unit;
  final double quantity;
  final int? image;

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
      quantity: (json['quantity'] ?? 0).toDouble(),
      image: json['image'] is int ? json['image'] : null,
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
