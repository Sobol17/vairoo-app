import 'package:ai_note/src/features/calendar/domain/entities/calendar_note.dart';

List<CalendarNote> todayCalendarNotes = [
  CalendarNote(
    id: 'note-today-1',
    date: DateTime(2025, 7, 26),
    title: 'Хороший день',
    preview:
        'Утром заходили в магазин с семьёй, потом гуляли в парке и чувствовали спокойствие.',
  ),
  CalendarNote(
    id: 'note-today-2',
    date: DateTime(2025, 7, 26),
    title: 'Дыхание помогает',
    preview:
        'Сделал дыхательную практику «4-7-8» и отметил, что уровень тревоги снизился.',
  ),
  CalendarNote(
    id: 'note-today-3',
    date: DateTime(2025, 7, 26),
    title: 'Встреча с друзьями',
    preview: 'Сходили на пикник. Смог отказаться от бокала, чувствую гордость.',
  ),
];

List<CalendarNote> allCalendarNotes = [
  ...todayCalendarNotes,
  CalendarNote(
    id: 'note-history-1',
    date: DateTime(2025, 7, 25),
    title: 'Тихий вечер',
    preview:
        'Читал книгу, записал мысли о прогрессе и отметил благодарность за поддержку близких.',
  ),
  CalendarNote(
    id: 'note-history-2',
    date: DateTime(2025, 7, 24),
    title: 'Переговоры на работе',
    preview:
        'Было напряжённо, но помогла пауза и дыхание. Записал, что сработало.',
  ),
  CalendarNote(
    id: 'note-history-3',
    date: DateTime(2025, 7, 23),
    title: 'Возвращение к дневнику',
    preview:
        'Перечитал первые записи и заметил, как изменилось восприятие триггеров.',
  ),
];
