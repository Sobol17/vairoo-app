class CalendarNote {
  const CalendarNote({
    required this.id,
    required this.date,
    required this.title,
    required this.preview,
  });

  final String id;
  final DateTime date;
  final String title;
  final String preview;
}
