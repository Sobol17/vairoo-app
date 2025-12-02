import 'package:Vairoo/src/features/plan/domain/entities/daily_plan.dart';

final sampleDayPlan = DailyPlan(
  id: 'sample-plan',
  date: DateTime.now(),
  status: PlanStatus.active,
  currentStep: PlanStep.morning,
  blocks: PlanBlocks(
    morning: [
      PlanActivityItem(
        id: 'sample-activity-1',
        templateId: 'template-1',
        title: 'Гидратация',
        description:
            'Носите с собой бутылку воды. Пейте регулярно. Иногда жажду путают с тягой.',
        timeOfDay: PlanTimeOfDay.morning,
        status: PlanActivityStatus.pending,
        order: 1,
        buttonText: 'Смотреть',
      ),
      PlanActivityItem(
        id: 'sample-activity-2',
        templateId: 'template-2',
        title: 'Осознанность в стрессовых ситуациях',
        description:
            'Если возникает стресс: сделайте 3 глубоких вдоха и задайте себе вопросы поддержки.',
        timeOfDay: PlanTimeOfDay.morning,
        status: PlanActivityStatus.pending,
        order: 2,
        buttonText: 'Смотреть',
      ),
    ],
    day: [
      PlanActivityItem(
        id: 'sample-activity-3',
        templateId: 'template-3',
        title: 'Здоровые перекусы',
        description: 'Фрукты/овощи, йогурт и т.д.',
        timeOfDay: PlanTimeOfDay.day,
        status: PlanActivityStatus.pending,
        order: 1,
        buttonText: 'Смотреть',
      ),
      PlanActivityItem(
        id: 'sample-activity-4',
        templateId: 'template-4',
        title: 'Физическая активность',
        description:
            'Даже 10-15 минут прогулки помогают снять напряжение и улучшить настроение.',
        timeOfDay: PlanTimeOfDay.day,
        status: PlanActivityStatus.pending,
        order: 2,
        buttonText: 'Смотреть',
      ),
    ],
    evening: [
      PlanActivityItem(
        id: 'sample-activity-5',
        templateId: 'template-5',
        title: 'Подведение итогов',
        description: 'Оцените свой прогресс за день и подведите итог.',
        timeOfDay: PlanTimeOfDay.evening,
        status: PlanActivityStatus.pending,
        order: 1,
        buttonText: 'Итоги',
      ),
    ],
  ),
);
