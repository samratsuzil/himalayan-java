import 'package:recipe_book/helpers/parse_media_id.dart';

class ProcedureStep {
  final String? description;
  final int? image;

  ProcedureStep({this.description, this.image});

  factory ProcedureStep.fromJson(Map<String, dynamic> json) {
    return ProcedureStep(
      description: json['description'] ?? '',
      image: parseMediaId(json['image']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description ?? '',
      'image': image,
    };
  }
}
