class ProcedureStep {
  final String description;
  final int imageId;

  ProcedureStep({
    required this.description,
    required this.imageId,
  });

  factory ProcedureStep.fromJson(Map<String, dynamic> json) {
    return ProcedureStep(
      description: json['description'] ?? '',
      imageId: json['image'] ?? 0,
    );
  }
}