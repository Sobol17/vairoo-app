import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  const Profile({
    required this.name,
    required this.sobrietyStartDate,
    this.birthDate,
    this.phone,
    this.email,
    this.dailyExpenses,
    this.dailyCalories,
    this.pushNotificationsEnabled = true,
    this.emailNotificationsEnabled = true,
  });

  final String name;
  final DateTime? sobrietyStartDate;
  final DateTime? birthDate;
  final String? phone;
  final String? email;
  final double? dailyExpenses;
  final double? dailyCalories;
  final bool pushNotificationsEnabled;
  final bool emailNotificationsEnabled;

  bool get isComplete =>
      name.isNotEmpty && sobrietyStartDate != null && phone?.isNotEmpty == true;

  Profile copyWith({
    String? name,
    DateTime? sobrietyStartDate,
    DateTime? birthDate,
    String? phone,
    String? email,
    double? dailyExpenses,
    double? dailyCalories,
    bool? pushNotificationsEnabled,
    bool? emailNotificationsEnabled,
  }) {
    return Profile(
      name: name ?? this.name,
      sobrietyStartDate: sobrietyStartDate ?? this.sobrietyStartDate,
      birthDate: birthDate ?? this.birthDate,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      dailyExpenses: dailyExpenses ?? this.dailyExpenses,
      dailyCalories: dailyCalories ?? this.dailyCalories,
      pushNotificationsEnabled:
          pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      emailNotificationsEnabled:
          emailNotificationsEnabled ?? this.emailNotificationsEnabled,
    );
  }

  @override
  List<Object?> get props => [
    name,
    sobrietyStartDate,
    birthDate,
    phone,
    email,
    dailyExpenses,
    dailyCalories,
    pushNotificationsEnabled,
    emailNotificationsEnabled,
  ];
}
