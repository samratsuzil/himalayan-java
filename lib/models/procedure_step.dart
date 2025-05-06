class ProcedureStep {
  final String? description;
  final int? image;

  ProcedureStep({this.description, this.image});

  factory ProcedureStep.fromJson(Map<String, dynamic> json) {
    return ProcedureStep(
      description: json['description'] ?? '',
      image: json['image'] is int ? json['image'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description ?? '',
      'image': image,
    };
  }
}
