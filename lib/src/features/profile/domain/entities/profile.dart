import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  const Profile({required this.name, required this.sobrietyStartDate});

  final String name;
  final DateTime? sobrietyStartDate;

  bool get isComplete => name.isNotEmpty && sobrietyStartDate != null;

  Profile copyWith({String? name, DateTime? sobrietyStartDate}) {
    return Profile(
      name: name ?? this.name,
      sobrietyStartDate: sobrietyStartDate ?? this.sobrietyStartDate,
    );
  }

  @override
  List<Object?> get props => [name, sobrietyStartDate];
}
