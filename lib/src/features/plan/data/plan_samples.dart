import 'package:ai_note/src/features/plan/domain/entities/daily_plan.dart';
import 'package:flutter/material.dart';

const sampleDayPlan = DailyPlan(
  period: 'День',
  subtitle: 'Будьте активны и осознанны!',
  activities: [
    PlanActivity(
      title: 'Гидратация',
      description:
          'Носите с собой бутылку воды. Пейте регулярно. Иногда жажду путают с тягой.',
      primaryActionLabel: 'Смотреть',
      secondaryActionLabel: 'Отметить',
      icon: Icons.water_drop_outlined,
    ),
    PlanActivity(
      title: 'Здоровые перекусы',
      description: 'Фрукты/овощи, йогурт и т.д.',
      primaryActionLabel: 'Смотреть',
      secondaryActionLabel: 'Отметить',
      icon: Icons.restaurant_outlined,
      route: '/home/recipes',
    ),
    PlanActivity(
      title: 'Осознанность в стрессовых ситуациях',
      description:
          'Если возникает стресс: сделайте 3 глубоких вдоха и задайте себе вопросы поддержки.',
      primaryActionLabel: 'Смотреть',
      secondaryActionLabel: 'Отметить',
      icon: Icons.self_improvement_outlined,
    ),
    PlanActivity(
      title: 'Физическая активность',
      description:
          'Даже 10-15 минут прогулки помогают снять напряжение и улучшить настроение.',
      primaryActionLabel: 'Смотреть',
      secondaryActionLabel: 'Отметить',
      icon: Icons.fitness_center_outlined,
    ),
  ],
  realityCheck: RealityCheck(
    title: '«Проверка реальности»',
    description:
        'Когда кажется, что «один раз не считается», вспомните последствия употребления и почему вы выбрали трезвость.',
    ctaLabel: 'Следующий шаг',
  ),
);
