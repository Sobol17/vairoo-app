import 'package:Vairoo/src/features/recipes/domain/entities/recipe.dart';

class RecipeModel extends Recipe {
  const RecipeModel({
    required super.id,
    required super.title,
    required super.durationMinutes,
    super.durationLabel,
    required super.tags,
    required super.mealType,
    required super.imageUrl,
    required super.ingredients,
    required super.instructions,
    super.description,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    final tags = _parseTags(json['tags']);
    final ingredients = _parseIngredients(json['ingredients']);
    final mealType = _parseMealType(
      json['mealType'] as String? ?? json['meal_type'] as String?,
    );
    return RecipeModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      durationMinutes: _parseDurationMinutes(
        json['durationMinutes'] ?? json['duration_minutes'],
      ),
      durationLabel: _parseDurationLabel(json),
      tags: tags,
      mealType: mealType,
      imageUrl:
          json['imageUrl'] as String? ?? json['image_url'] as String? ?? '',
      ingredients: ingredients,
      instructions: json['instructions'] as String? ?? '',
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'durationMinutes': durationMinutes,
      if (durationLabel != null) 'duration': durationLabel,
      'tags': tags,
      'mealType': mealType.name.toUpperCase(),
      'imageUrl': imageUrl,
      'ingredients': ingredients
          .map(
            (ingredient) => {
              'name': ingredient.name,
              'amount': ingredient.amount,
            },
          )
          .toList(),
      'instructions': instructions,
      if (description != null) 'description': description,
    };
  }

  static String? _parseDurationLabel(Map<String, dynamic> json) {
    return json['duration'] as String? ??
        json['durationLabel'] as String? ??
        json['duration_label'] as String?;
  }

  static int _parseDurationMinutes(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is double) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  static List<String> _parseTags(dynamic raw) {
    final payload = raw as List<dynamic>?;
    if (payload == null) {
      return const [];
    }
    return payload.whereType<String>().toList(growable: false);
  }

  static List<RecipeIngredient> _parseIngredients(dynamic raw) {
    final payload = raw as List<dynamic>?;
    if (payload == null) {
      return const [];
    }
    return payload
        .whereType<Map<String, dynamic>>()
        .map(
          (json) => RecipeIngredient(
            name: json['name'] as String? ?? '',
            amount: json['amount'] as String? ?? '',
          ),
        )
        .toList(growable: false);
  }

  static RecipeMealType _parseMealType(String? raw) {
    switch (raw?.toUpperCase()) {
      case 'BREAKFAST':
        return RecipeMealType.breakfast;
      case 'LUNCH':
        return RecipeMealType.lunch;
      case 'DINNER':
        return RecipeMealType.dinner;
      default:
        return RecipeMealType.breakfast;
    }
  }
}
