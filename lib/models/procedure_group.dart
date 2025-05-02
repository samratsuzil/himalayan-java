import 'procedure_step.dart';

class ProcedureGroup {
  final String groupName;
  final List<ProcedureStep> steps;

  ProcedureGroup({
    required this.groupName,
    required this.steps,
  });

  factory ProcedureGroup.fromJson(Map<String, dynamic> json) {
    final sub = json['sub_procedure'] ?? {};
    final stepsJson = sub['sub_procedures'] ?? [];
    return ProcedureGroup(
      groupName: sub['name'] ?? '',
      steps: List<Map<String, dynamic>>.from(stepsJson)
          .map((e) => ProcedureStep.fromJson(e))
          .toList(),
    );
  }
}