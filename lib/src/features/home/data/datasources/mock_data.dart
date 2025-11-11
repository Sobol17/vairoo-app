import 'package:ai_note/src/features/home/domain/entities/home_plan.dart';

const List<HomeRoutinePlan> mockRoutines = [
  HomeRoutinePlan(
    id: 'morning',
    title: 'Заложите прочный фундамент на день',
    tagLabel: 'Утро',
    coverImageUrl:
        'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=800&q=80',
    steps: ['Здоровый завтрак', 'Утренний ритуал'],
  ),
  HomeRoutinePlan(
    id: 'day',
    title: 'Поддержите фокус в течение дня',
    tagLabel: 'День',
    coverImageUrl:
        'https://images.unsplash.com/photo-1435224654926-ecc9f7fa028c?auto=format&fit=crop&w=800&q=80',
    steps: ['Гидратация', 'Физическая активность', 'Здоровые перекусы'],
  ),
  HomeRoutinePlan(
    id: 'evening',
    title: 'Плавное завершение дня',
    tagLabel: 'Вечер',
    coverImageUrl:
        'https://images.unsplash.com/photo-1435224654926-ecc9f7fa028c?auto=format&fit=crop&w=800&q=80',
    steps: ['Гидратация', 'Физическая активность', 'Здоровые перекусы'],
  ),
];
