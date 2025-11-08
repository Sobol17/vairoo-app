import 'dart:convert';

import 'package:ai_note/src/features/profile/domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required super.name,
    required super.sobrietyStartDate,
    super.birthDate,
    super.phone,
    super.email,
    super.dailyExpenses,
    super.dailyCalories,
    super.pushNotificationsEnabled,
    super.emailNotificationsEnabled,
  });

  factory ProfileModel.initial() {
    final now = DateTime.now();
    return ProfileModel(
      name: 'Иван Иванович',
      sobrietyStartDate: DateTime(now.year, now.month, now.day - 1),
      birthDate: DateTime(now.year - 30, now.month, now.day),
      phone: '+7 (999) 123-45-67',
      email: '',
      dailyExpenses: 230,
      dailyCalories: null,
      pushNotificationsEnabled: true,
      emailNotificationsEnabled: true,
    );
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final rawDate = json['sobrietyStartDate'] as String?;
    return ProfileModel(
      name: json['name'] as String? ?? '',
      sobrietyStartDate: rawDate == null || rawDate.isEmpty
          ? null
          : DateTime.parse(rawDate),
      birthDate:
          json['birthDate'] != null && (json['birthDate'] as String).isNotEmpty
          ? DateTime.parse(json['birthDate'] as String)
          : null,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      dailyExpenses: (json['dailyExpenses'] as num?)?.toDouble(),
      dailyCalories: (json['dailyCalories'] as num?)?.toDouble(),
      pushNotificationsEnabled:
          json['pushNotificationsEnabled'] as bool? ?? true,
      emailNotificationsEnabled:
          json['emailNotificationsEnabled'] as bool? ?? true,
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
      'pushNotificationsEnabled': pushNotificationsEnabled,
      'emailNotificationsEnabled': emailNotificationsEnabled,
    };
  }

  String toEncodedJson() => jsonEncode(toJson());

  static ProfileModel fromEncoded(String encoded) {
    return ProfileModel.fromJson(jsonDecode(encoded) as Map<String, dynamic>);
  }
}
