class HomeQuote {
  const HomeQuote({required this.text, this.author});

  final String text;
  final String? author;
}

class HomeSobriety {
  const HomeSobriety({
    required this.startDate,
    required this.days,
    required this.hours,
    required this.minutes,
  });

  final DateTime startDate;
  final int days;
  final int hours;
  final int minutes;
}

class HomePlanEntry {
  const HomePlanEntry({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.tags,
    required this.checklist,
    required this.callToAction,
    this.coverImageUrl,
  });

  final String id;
  final String title;
  final String subtitle;
  final List<String> tags;
  final List<String> checklist;
  final String? callToAction;
  final String? coverImageUrl;
}

class HomeSavings {
  const HomeSavings({
    required this.amount,
    required this.currency,
    required this.caption,
  });

  final String amount;
  final String currency;
  final String caption;
}

class HomeAchievement {
  const HomeAchievement({
    required this.title,
    required this.description,
    required this.actionLabel,
  });

  final String title;
  final String description;
  final String actionLabel;
}

class HomeKnowledge {
  const HomeKnowledge({
    required this.title,
    required this.description,
    required this.actionLabel,
  });

  final String title;
  final String description;
  final String actionLabel;
}

class HomeCalories {
  const HomeCalories({
    required this.title,
    required this.value,
    required this.description,
    required this.actionLabel,
  });

  final String title;
  final String value;
  final String description;
  final String actionLabel;
}

class HomeData {
  const HomeData({
    required this.quote,
    required this.sobriety,
    required this.dayNumber,
    required this.date,
    required this.plan,
    required this.savings,
    required this.achievements,
    required this.knowledge,
    required this.calories,
    required this.notificationsUnread,
    required this.totalSaved,
  });

  final HomeQuote quote;
  final HomeSobriety sobriety;
  final int dayNumber;
  final DateTime date;
  final List<HomePlanEntry> plan;
  final HomeSavings savings;
  final List<HomeAchievement> achievements;
  final List<HomeKnowledge> knowledge;
  final HomeCalories calories;
  final int notificationsUnread;
  final String totalSaved;
}
