import 'dart:convert';

import 'package:ai_note/src/features/profile/domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required super.id,
    required super.name,
    required super.sobrietyStartDate,
    super.birthDate,
    super.phone,
    super.email,
    super.dailyExpenses,
    super.dailyCalories,
    super.goal,
    super.habitSpending,
    super.pushNotificationsEnabled,
    super.emailNotificationsEnabled,
    super.createdAt,
    super.updatedAt,
  });

  const ProfileModel.empty() : this(id: '', name: '', sobrietyStartDate: null);

  factory ProfileModel.fromProfile(Profile profile) {
    return ProfileModel(
      id: profile.id,
      name: profile.name,
      sobrietyStartDate: profile.sobrietyStartDate ?? DateTime.now(),
      birthDate: profile.birthDate,
      phone: profile.phone,
      email: profile.email,
      dailyExpenses: profile.dailyExpenses,
      dailyCalories: profile.dailyCalories,
      goal: profile.goal,
      habitSpending: profile.habitSpending,
      pushNotificationsEnabled: profile.pushNotificationsEnabled,
      emailNotificationsEnabled: profile.emailNotificationsEnabled,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
    );
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final rawDate =
        (json['sobrietyStartDate'] ?? json['sobriety_start_date']) as String?;
    return ProfileModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      sobrietyStartDate: rawDate == null || rawDate.isEmpty
          ? null
          : DateTime.parse(rawDate),
      birthDate:
          json['date_of_birth'] != null &&
              (json['date_of_birth'] as String).isNotEmpty
          ? DateTime.parse(json['date_of_birth'] as String)
          : null,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      dailyExpenses: _parseDecimal(
        json['habit_spending'] ?? json['habit_spending'],
      ),
      dailyCalories: _parseDecimal(
        json['daily_calories'] ?? json['dailyCalories'],
      ),
      goal: json['goal'] as String?,
      habitSpending: _parseDecimal(json['habit_spending']),
      pushNotificationsEnabled:
          json['push_notifications_enabled'] as bool? ??
          json['pushNotificationsEnabled'] as bool? ??
          true,
      emailNotificationsEnabled:
          json['email_notifications_enabled'] as bool? ??
          json['emailNotificationsEnabled'] as bool? ??
          true,
      createdAt: _parseDate(json['created_at'] as String?),
      updatedAt: _parseDate(json['updated_at'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'sobrietyStartDate': sobrietyStartDate?.toIso8601String() ?? '',
      'birthDate': birthDate?.toIso8601String() ?? '',
      'phone': phone ?? '',
      'email': email ?? '',
      'dailyExpenses': dailyExpenses,
      'dailyCalories': dailyCalories,
      'goal': goal,
      'habit_spending': habitSpending,
      'push_notifications_enabled': pushNotificationsEnabled,
      'email_notifications_enabled': emailNotificationsEnabled,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String toEncodedJson() => jsonEncode(toJson());

  static ProfileModel fromEncoded(String encoded) {
    return ProfileModel.fromJson(jsonDecode(encoded) as Map<String, dynamic>);
  }

  static DateTime? _parseDate(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }
    return DateTime.tryParse(raw);
  }

  static double? _parseDecimal(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }
}
