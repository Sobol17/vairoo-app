import 'package:Vairoo/src/features/plan/domain/entities/daily_plan.dart';

class PlanStepContent {
  const PlanStepContent({
    required this.subtitle,
    required this.infoTitle,
    required this.infoDescription,
    required this.ctaLabel,
  });

  final String subtitle;
  final String infoTitle;
  final String infoDescription;
  final String ctaLabel;
}

const PlanStepContent _defaultContent = PlanStepContent(
  subtitle: 'Продолжайте выполнять активности плана',
  infoTitle: 'Отличная работа',
  infoDescription:
      'Все активности выполнены. Закрепите результат и продолжайте следовать плану.',
  ctaLabel: 'На главную',
);

const Map<PlanStep, PlanStepContent> _stepContentOverrides = {
  PlanStep.morning: PlanStepContent(
    subtitle: 'Заложите прочный фундамент на день',
    infoTitle: 'План на день',
    infoDescription:
        '1. Мысленно или письменно обозначьте ключевые точки дня.\n'
        '2. Отметьте ситуации повышенного риска (можно сделать при написании заметок).\n'
        '3. Продумайте ситуации сейчас.',
    ctaLabel: 'Следующий шаг',
  ),
  PlanStep.day: PlanStepContent(
    subtitle: 'Будьте активны и осознанны!',
    infoTitle: '«Проверка реальности»',
    infoDescription:
        'Когда кажется, что «один раз не считается» или «я контролирую», напомните себе:\n\n'
        '1. Почему вы выбрали трезвость? Вспомните негативные последствия употреблений.',
    ctaLabel: 'Следующий шаг',
  ),
  PlanStep.evening: PlanStepContent(
    subtitle: 'Расслабление',
    infoTitle: 'Избегайте триггеров',
    infoDescription:
        'Если определенные места, люди или онлайн-активность вызывают тягу — '
        'сознательно избегайте их сегодня.\n\nЗамените на безопасные альтернативы '
        '(для этого всегда держите при себе таблицу «ситуации повышенного риска»).',
    ctaLabel: 'Завершить',
  ),
  PlanStep.finished: PlanStepContent(
    subtitle: 'День завершен',
    infoTitle: 'Гордимся вами',
    infoDescription:
        'Отметьте в дневнике ключевые открытия и эмоции — это поможет закрепить результат.',
    ctaLabel: 'Продолжить путь трезвости',
  ),
};

PlanStepContent getPlanStepContent(PlanStep step) {
  return _stepContentOverrides[step] ?? _defaultContent;
}
