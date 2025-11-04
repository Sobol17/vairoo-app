import 'dart:convert';

import 'package:ai_note/src/features/profile/domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({required super.name, required super.sobrietyStartDate});

  factory ProfileModel.initial() {
    final now = DateTime.now();
    return ProfileModel(
      name: '',
      sobrietyStartDate: DateTime(now.year, now.month, now.day),
    );
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final rawDate = json['sobrietyStartDate'] as String?;
    return ProfileModel(
      name: json['name'] as String? ?? '',
      sobrietyStartDate: rawDate == null || rawDate.isEmpty
          ? null
          : DateTime.parse(rawDate),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'sobrietyStartDate': sobrietyStartDate?.toIso8601String() ?? '',
    };
  }

  String toEncodedJson() => jsonEncode(toJson());

  static ProfileModel fromEncoded(String encoded) {
    return ProfileModel.fromJson(jsonDecode(encoded) as Map<String, dynamic>);
  }
}
