import 'package:equatable/equatable.dart';

enum RecipeMealType { breakfast, lunch, dinner }

extension RecipeMealTypeLabel on RecipeMealType {
  String get label {
    switch (this) {
      case RecipeMealType.breakfast:
        return 'Завтрак';
      case RecipeMealType.lunch:
        return 'Обед';
      case RecipeMealType.dinner:
        return 'Ужин';
    }
  }
}

class RecipeIngredient extends Equatable {
  const RecipeIngredient({required this.name, required this.amount});

  final String name;
  final String amount;

  @override
  List<Object> get props => [name, amount];
}

class Recipe extends Equatable {
  const Recipe({
    required this.id,
    required this.title,
    required this.durationMinutes,
    this.durationLabel,
    required this.tags,
    required this.mealType,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    this.description,
  });

  final String id;
  final String title;
  final int durationMinutes;
  final String? durationLabel;
  final List<String> tags;
  final RecipeMealType mealType;
  final String imageUrl;
  final List<RecipeIngredient> ingredients;
  final String instructions;
  final String? description;

  String get durationDisplay {
    if (durationLabel != null && durationLabel!.isNotEmpty) {
      return durationLabel!;
    }
    return '$durationMinutes мин.';
  }

  @override
  List<Object?> get props => [
    id,
    title,
    durationMinutes,
    durationLabel,
    tags,
    mealType,
    imageUrl,
    ingredients,
    instructions,
    description,
  ];
}
