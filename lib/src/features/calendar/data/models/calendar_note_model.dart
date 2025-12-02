import 'package:Vairoo/src/features/calendar/domain/entities/calendar_note.dart';

class CalendarNoteModel extends CalendarNote {
  const CalendarNoteModel({
    required super.id,
    required super.date,
    required super.title,
    required super.preview,
    required super.feelings,
    required super.thoughts,
    required super.actions,
    required super.isRisk,
    super.riskDescription,
    required super.isRelapse,
    super.relapseDescription,
  });

  factory CalendarNoteModel.fromJson(Map<String, dynamic> json) {
    final dateString = json['date'] as String? ?? '';
    return CalendarNoteModel(
      id: json['id']?.toString() ?? '',
      date: DateTime.tryParse(dateString)?.toLocal() ?? DateTime.now(),
      title: json['title'] as String? ?? '',
      preview: json['preview'] as String? ?? '',
      feelings: json['feelings'] as String? ?? '',
      thoughts: json['thoughts'] as String? ?? '',
      actions: json['actions'] as String? ?? '',
      isRisk: json['is_risk'] as bool? ?? json['isRisk'] as bool? ?? false,
      riskDescription:
          json['risk_description'] as String? ??
          json['riskDescription'] as String?,
      isRelapse:
          json['is_relapse'] as bool? ?? json['isRelapse'] as bool? ?? false,
      relapseDescription:
          json['relapse_description'] as String? ??
          json['relapseDescription'] as String?,
    );
  }

  factory CalendarNoteModel.fromEntity(CalendarNote note) {
    return CalendarNoteModel(
      id: note.id,
      date: note.date,
      title: note.title,
      preview: note.preview,
      feelings: note.feelings,
      thoughts: note.thoughts,
      actions: note.actions,
      isRisk: note.isRisk,
      riskDescription: note.riskDescription,
      isRelapse: note.isRelapse,
      relapseDescription: note.relapseDescription,
    );
  }

  Map<String, dynamic> toRequestJson({bool includeId = false}) {
    return <String, dynamic>{
      if (includeId) 'id': id,
      'date': date.toUtc().toIso8601String(),
      'feelings': feelings,
      'thoughts': thoughts,
      'actions': actions,
      'is_risk': isRisk,
      'risk_description': riskDescription,
      'is_relapse': isRelapse,
      'relapse_description': relapseDescription,
      'title': title,
      'preview': preview,
    };
  }
}
