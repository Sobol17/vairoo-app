import 'package:Vairoo/src/features/home/domain/entities/home_data.dart';

class HomeDataModel extends HomeData {
  const HomeDataModel({
    required super.quote,
    required super.sobriety,
    required super.dayNumber,
    required super.date,
    required super.plan,
    required super.savings,
    required super.achievements,
    required super.knowledge,
    required super.calories,
    required super.notificationsUnread,
    required super.totalSaved,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    final quoteJson = json['quote'] as Map<String, dynamic>? ?? const {};
    final sobrietyJson = json['sobriety'] as Map<String, dynamic>? ?? const {};
    final planJson = json['plan'] as List<dynamic>? ?? const [];
    final savingsJson = json['savings'] as Map<String, dynamic>? ?? const {};
    final achievementsJson = json['achievements'] as List<dynamic>? ?? const [];
    final knowledgeJson = json['knowledge'] as List<dynamic>? ?? const [];
    final caloriesJson = json['calories'] as Map<String, dynamic>? ?? const {};
    final totalSavedValue =
        (json['total_saved'] as String?) ??
        (savingsJson['amount'] as String?) ??
        '0';

    return HomeDataModel(
      quote: HomeQuote(
        text: quoteJson['text'] as String? ?? '',
        author: quoteJson['author'] as String?,
      ),
      sobriety: HomeSobriety(
        startDate: _parseDate(sobrietyJson['start_date'] as String?),
        days: (sobrietyJson['days'] as num?)?.toInt() ?? 0,
        hours: (sobrietyJson['hours'] as num?)?.toInt() ?? 0,
        minutes: (sobrietyJson['minutes'] as num?)?.toInt() ?? 0,
      ),
      dayNumber: (json['day_number'] as num?)?.toInt() ?? 1,
      date: _parseDate(json['date'] as String?),
      plan: planJson
          .whereType<Map<String, dynamic>>()
          .map(
            (item) => HomePlanEntry(
              id: item['id'] as String? ?? '',
              title: item['title'] as String? ?? '',
              subtitle: item['subtitle'] as String? ?? '',
              tags:
                  (item['tags'] as List<dynamic>?)
                      ?.whereType<String>()
                      .toList() ??
                  const [],
              checklist:
                  (item['checklist'] as List<dynamic>?)
                      ?.whereType<String>()
                      .toList() ??
                  const [],
              callToAction: item['cta'] as String?,
              coverImageUrl: item['cover_image_url'] as String?,
            ),
          )
          .where((entry) => entry.id.isNotEmpty)
          .toList(growable: false),
      savings: HomeSavings(
        amount: savingsJson['amount'] as String? ?? '0',
        currency: savingsJson['currency'] as String? ?? '₽',
        caption: savingsJson['caption'] as String? ?? '',
      ),
      achievements: achievementsJson
          .whereType<Map<String, dynamic>>()
          .map(
            (item) => HomeAchievement(
              title: item['title'] as String? ?? '',
              description: item['description'] as String? ?? '',
              actionLabel: item['action_label'] as String? ?? '',
            ),
          )
          .toList(growable: false),
      knowledge: knowledgeJson
          .whereType<Map<String, dynamic>>()
          .map(
            (item) => HomeKnowledge(
              title: item['title'] as String? ?? '',
              description: item['description'] as String? ?? '',
              actionLabel: item['action_label'] as String? ?? '',
            ),
          )
          .toList(growable: false),
      calories: HomeCalories(
        title: caloriesJson['title'] as String? ?? '',
        value: caloriesJson['value'] as String? ?? '',
        description: caloriesJson['description'] as String? ?? '',
        actionLabel: caloriesJson['action_label'] as String? ?? '',
      ),
      notificationsUnread: (json['notifications_unread'] as num?)?.toInt() ?? 0,
      totalSaved: totalSavedValue,
    );
  }

  static DateTime _parseDate(String? date) {
    if (date == null || date.isEmpty) {
      return DateTime.now();
    }
    return DateTime.tryParse(date) ?? DateTime.now();
  }
}
