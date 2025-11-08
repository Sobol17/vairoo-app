import 'package:ai_note/src/features/recipes/data/models/recipe_model.dart';
import 'package:ai_note/src/features/recipes/domain/entities/recipe.dart';

class RecipesLocalDataSource {
  const RecipesLocalDataSource();

  Future<List<RecipeModel>> fetchRecipes() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _sampleRecipes;
  }
}

const _sampleRecipes = [
  RecipeModel(
    id: 'breakfast-1',
    title: 'Тосты с сыром и томатами',
    durationMinutes: 5,
    tags: ['Полезно', 'Быстро'],
    mealType: RecipeMealType.breakfast,
    imageUrl:
        'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?auto=format&fit=crop&w=800&q=80',
    ingredients: [
      RecipeIngredient(name: 'Цельнозерновой хлеб', amount: '2 ломтика'),
      RecipeIngredient(name: 'Твёрдый сыр', amount: '50 г'),
      RecipeIngredient(name: 'Помидор', amount: '1/2'),
      RecipeIngredient(name: 'Салат', amount: '1 лист'),
      RecipeIngredient(name: 'Оливковое масло', amount: '5 мл'),
    ],
    instructions:
        'Подсушите хлеб в тостере или на сухой сковороде. '
        'Выложите сыр и тонко нарезанный помидор, прогрейте 30–60 секунд, чтобы сыр расплавился. '
        'Добавьте салат и любимые специи.',
    description: 'Заложите прочный фундамент дня',
  ),
  RecipeModel(
    id: 'breakfast-2',
    title: 'Йогурт с ягодами',
    durationMinutes: 5,
    tags: ['Полезно', 'Легко'],
    mealType: RecipeMealType.breakfast,
    imageUrl:
        'https://images.unsplash.com/photo-1506086679524-493c64fdfaa6?auto=format&fit=crop&w=800&q=80',
    ingredients: [
      RecipeIngredient(name: 'Греческий йогурт', amount: '150 г'),
      RecipeIngredient(name: 'Замороженные ягоды', amount: '50 г'),
      RecipeIngredient(name: 'Мёд', amount: '1 ч. л.'),
      RecipeIngredient(name: 'Орехи', amount: 'по вкусу'),
    ],
    instructions:
        'Смешайте йогурт с ягодами, добавьте мёд и орехи. '
        'Это быстрый способ получить белок и клетчатку.',
    description: 'Сладкий, но полезный завтрак',
  ),
  RecipeModel(
    id: 'lunch-1',
    title: 'Тёплый салат с нутом',
    durationMinutes: 15,
    tags: ['Сыто', 'Вегги'],
    mealType: RecipeMealType.lunch,
    imageUrl:
        'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=800&q=80',
    ingredients: [
      RecipeIngredient(name: 'Нут отварной', amount: '150 г'),
      RecipeIngredient(name: 'Помидоры черри', amount: '6 шт.'),
      RecipeIngredient(name: 'Шпинат', amount: '2 горсти'),
      RecipeIngredient(name: 'Оливковое масло', amount: '1 ст. л.'),
    ],
    instructions:
        'Обжарьте нут на оливковом масле, добавьте помидоры и шпинат. '
        'Приправьте солью и перцем, подавайте тёплым.',
  ),
  RecipeModel(
    id: 'dinner-1',
    title: 'Лёгкая паста с овощами',
    durationMinutes: 20,
    tags: ['Тёплое', 'Комфорт'],
    mealType: RecipeMealType.dinner,
    imageUrl:
        'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?auto=format&fit=crop&w=800&q=80',
    ingredients: [
      RecipeIngredient(name: 'Паста', amount: '120 г'),
      RecipeIngredient(name: 'Цукини', amount: '1/2'),
      RecipeIngredient(name: 'Оливковое масло', amount: '1 ст. л.'),
      RecipeIngredient(name: 'Чеснок', amount: '1 зубчик'),
    ],
    instructions:
        'Отварите пасту до состояния al dente. '
        'Обжарьте цукини и чеснок, смешайте с пастой и маслом.',
  ),
];
