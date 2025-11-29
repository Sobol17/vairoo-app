import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  const Profile({
    required this.id,
    required this.name,
    required this.sobrietyStartDate,
    this.birthDate,
    this.phone,
    this.email,
    this.dailyExpenses,
    this.dailyCalories,
    this.goal,
    this.habitSpending,
    this.pushNotificationsEnabled = true,
    this.emailNotificationsEnabled = true,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final DateTime? sobrietyStartDate;
  final DateTime? birthDate;
  final String? phone;
  final String? email;
  final double? dailyExpenses;
  final double? dailyCalories;
  final String? goal;
  final double? habitSpending;
  final bool pushNotificationsEnabled;
  final bool emailNotificationsEnabled;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isComplete =>
      name.isNotEmpty && sobrietyStartDate != null && phone?.isNotEmpty == true;

  Profile copyWith({
    String? id,
    String? name,
    DateTime? sobrietyStartDate,
    DateTime? birthDate,
    String? phone,
    String? email,
    double? dailyExpenses,
    double? dailyCalories,
    String? goal,
    double? habitSpending,
    bool? pushNotificationsEnabled,
    bool? emailNotificationsEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      sobrietyStartDate: sobrietyStartDate ?? this.sobrietyStartDate,
      birthDate: birthDate ?? this.birthDate,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      dailyExpenses: dailyExpenses ?? this.dailyExpenses,
      dailyCalories: dailyCalories ?? this.dailyCalories,
      goal: goal ?? this.goal,
      habitSpending: habitSpending ?? this.habitSpending,
      pushNotificationsEnabled:
          pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      emailNotificationsEnabled:
          emailNotificationsEnabled ?? this.emailNotificationsEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    sobrietyStartDate,
    birthDate,
    phone,
    email,
    dailyExpenses,
    dailyCalories,
    goal,
    habitSpending,
    pushNotificationsEnabled,
    emailNotificationsEnabled,
    createdAt,
    updatedAt,
  ];
}
