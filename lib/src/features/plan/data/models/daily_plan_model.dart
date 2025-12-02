import 'package:Vairoo/src/features/plan/domain/entities/daily_plan.dart';

class DailyPlanModel extends DailyPlan {
  DailyPlanModel({
    required super.id,
    required super.date,
    required super.status,
    required super.currentStep,
    required super.blocks,
  });

  factory DailyPlanModel.fromJson(Map<String, dynamic> json) {
    final blocksJson = json['blocks'] as Map<String, dynamic>? ?? const {};
    return DailyPlanModel(
      id: _asString(json['id']),
      date: _parseDate(json['date'] as String?),
      status: PlanStatus.fromApiValue(json['status'] as String?),
      currentStep: PlanStep.fromApiValue(json['current_step'] as String?),
      blocks: PlanBlocks(
        morning: _parseActivities(blocksJson['morning']),
        day: _parseActivities(blocksJson['day']),
        evening: _parseActivities(blocksJson['evening']),
      ),
    );
  }

  static List<PlanActivityItem> _parseActivities(Object? value) {
    final raw = (value as List<dynamic>?)
        ?.whereType<Map<String, dynamic>>()
        .map(PlanActivityItemModel.fromJson)
        .where((item) => item.id.isNotEmpty)
        .toList();
    if (raw == null || raw.isEmpty) {
      return const [];
    }
    raw.sort((a, b) => a.order.compareTo(b.order));
    return List<PlanActivityItem>.unmodifiable(raw);
  }

  static DateTime _parseDate(String? raw) {
    if (raw == null || raw.isEmpty) {
      return DateTime.now();
    }
    return DateTime.tryParse(raw) ?? DateTime.now();
  }
}

class PlanActivityItemModel extends PlanActivityItem {
  PlanActivityItemModel({
    required super.id,
    required super.templateId,
    required super.title,
    required super.description,
    required super.timeOfDay,
    required super.status,
    required super.order,
    super.type,
    super.buttonText,
  });

  factory PlanActivityItemModel.fromJson(Map<String, dynamic> json) {
    return PlanActivityItemModel(
      id: _asString(json['id']),
      templateId: _asString(json['template_id']),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      timeOfDay: PlanTimeOfDay.fromApiValue(json['time_of_day'] as String?),
      status: PlanActivityStatus.fromApiValue(json['status'] as String?),
      order: (json['order'] as num?)?.toInt() ?? 0,
      type: json['type'] as String?,
      buttonText: json['button_text'] as String?,
    );
  }
}

String _asString(Object? value) {
  if (value == null) {
    return '';
  }
  if (value is String) {
    return value;
  }
  return value.toString();
}
