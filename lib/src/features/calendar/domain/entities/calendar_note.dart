class CalendarNote {
  const CalendarNote({
    required this.id,
    required this.date,
    required this.title,
    required this.preview,
    this.feelings = '',
    this.thoughts = '',
    this.actions = '',
    this.isRisk = false,
    this.riskDescription,
    this.isRelapse = false,
    this.relapseDescription,
  });

  final String id;
  final DateTime date;
  final String title;
  final String preview;
  final String feelings;
  final String thoughts;
  final String actions;
  final bool isRisk;
  final String? riskDescription;
  final bool isRelapse;
  final String? relapseDescription;

  CalendarNote copyWith({
    String? id,
    DateTime? date,
    String? title,
    String? preview,
    String? feelings,
    String? thoughts,
    String? actions,
    bool? isRisk,
    String? riskDescription,
    bool? isRelapse,
    String? relapseDescription,
  }) {
    return CalendarNote(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      preview: preview ?? this.preview,
      feelings: feelings ?? this.feelings,
      thoughts: thoughts ?? this.thoughts,
      actions: actions ?? this.actions,
      isRisk: isRisk ?? this.isRisk,
      riskDescription: riskDescription ?? this.riskDescription,
      isRelapse: isRelapse ?? this.isRelapse,
      relapseDescription: relapseDescription ?? this.relapseDescription,
    );
  }
}
