import 'package:flutter/material.dart';

import 'package:ai_note/src/features/recipes/domain/entities/recipe.dart';
import 'package:ai_note/src/features/recipes/domain/repositories/recipes_repository.dart';

class RecipesController extends ChangeNotifier {
  RecipesController({required RecipesRepository repository})
    : _repository = repository;

  final RecipesRepository _repository;

  bool _isLoading = false;
  List<Recipe> _recipes = const [];

  bool get isLoading => _isLoading;
  List<Recipe> get recipes => _recipes;

  Map<RecipeMealType, List<Recipe>> get groupedRecipes {
    final map = <RecipeMealType, List<Recipe>>{};
    for (final recipe in _recipes) {
      map.putIfAbsent(recipe.mealType, () => <Recipe>[]).add(recipe);
    }
    return map;
  }

  Future<void> load() async {
    _setLoading(true);
    try {
      _recipes = await _repository.fetchRecipes();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    if (_isLoading == value) {
      return;
    }
    _isLoading = value;
    notifyListeners();
  }
}
