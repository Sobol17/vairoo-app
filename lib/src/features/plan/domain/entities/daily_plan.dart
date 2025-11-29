class DailyPlan {
  const DailyPlan({
    required this.id,
    required this.date,
    required this.status,
    required this.currentStep,
    required this.blocks,
  });

  final String id;
  final DateTime date;
  final PlanStatus status;
  final PlanStep currentStep;
  final PlanBlocks blocks;

  bool get isCompleted => status == PlanStatus.completed;
}

class PlanBlocks {
  const PlanBlocks({
    this.morning = const [],
    this.day = const [],
    this.evening = const [],
  });

  final List<PlanActivityItem> morning;
  final List<PlanActivityItem> day;
  final List<PlanActivityItem> evening;

  List<PlanActivityItem> byTimeOfDay(PlanTimeOfDay timeOfDay) {
    switch (timeOfDay) {
      case PlanTimeOfDay.morning:
        return morning;
      case PlanTimeOfDay.day:
        return day;
      case PlanTimeOfDay.evening:
        return evening;
    }
  }

  List<PlanActivityItem> itemsForStep(PlanStep step) {
    final timeOfDay = step.asTimeOfDay;
    if (timeOfDay == null) {
      return const [];
    }
    return byTimeOfDay(timeOfDay);
  }
}

class PlanActivityItem {
  const PlanActivityItem({
    required this.id,
    required this.templateId,
    required this.title,
    required this.description,
    required this.timeOfDay,
    required this.status,
    required this.order,
    this.type,
    this.buttonText,
  });

  final String id;
  final String templateId;
  final String title;
  final String description;
  final PlanTimeOfDay timeOfDay;
  final PlanActivityStatus status;
  final int order;
  final String? type;
  final String? buttonText;

  bool get isDone => status == PlanActivityStatus.done;
}

enum PlanStatus {
  active,
  completed,
  expired;

  static PlanStatus fromApiValue(String? value) {
    switch (value) {
      case 'COMPLETED':
        return PlanStatus.completed;
      case 'EXPIRED':
        return PlanStatus.expired;
      default:
        return PlanStatus.active;
    }
  }

  String get label {
    switch (this) {
      case PlanStatus.active:
        return 'Активен';
      case PlanStatus.completed:
        return 'Завершен';
      case PlanStatus.expired:
        return 'Истек';
    }
  }
}

enum PlanStep {
  morning,
  day,
  evening,
  finished;

  static PlanStep fromApiValue(String? value) {
    switch (value) {
      case 'DAY':
        return PlanStep.day;
      case 'EVENING':
        return PlanStep.evening;
      case 'FINISHED':
        return PlanStep.finished;
      default:
        return PlanStep.morning;
    }
  }

  String get label {
    switch (this) {
      case PlanStep.morning:
        return 'Утро';
      case PlanStep.day:
        return 'День';
      case PlanStep.evening:
        return 'Вечер';
      case PlanStep.finished:
        return 'Завершен';
    }
  }

  PlanTimeOfDay? get asTimeOfDay {
    switch (this) {
      case PlanStep.morning:
        return PlanTimeOfDay.morning;
      case PlanStep.day:
        return PlanTimeOfDay.day;
      case PlanStep.evening:
        return PlanTimeOfDay.evening;
      case PlanStep.finished:
        return null;
    }
  }
}

enum PlanTimeOfDay {
  morning,
  day,
  evening;

  static PlanTimeOfDay fromApiValue(String? value) {
    switch (value) {
      case 'DAY':
        return PlanTimeOfDay.day;
      case 'EVENING':
        return PlanTimeOfDay.evening;
      default:
        return PlanTimeOfDay.morning;
    }
  }

  String get label {
    switch (this) {
      case PlanTimeOfDay.morning:
        return 'Утро';
      case PlanTimeOfDay.day:
        return 'День';
      case PlanTimeOfDay.evening:
        return 'Вечер';
    }
  }
}

enum PlanActivityStatus {
  pending,
  done;

  static PlanActivityStatus fromApiValue(String? value) {
    switch (value) {
      case 'DONE':
        return PlanActivityStatus.done;
      default:
        return PlanActivityStatus.pending;
    }
  }
}
