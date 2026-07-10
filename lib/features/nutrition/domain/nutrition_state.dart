import '../../../core/models/nutrition_targets.dart';
import 'nutrition_entry.dart';

class NutritionState {
  const NutritionState({
    required this.targets,
    required this.mealLog,
    required this.region,
    required this.suggestions,
  });

  final NutritionTargets targets;
  final List<NutritionEntry> mealLog;
  final String region;
  final List<String> suggestions;

  factory NutritionState.initial() {
    return const NutritionState(
      targets: NutritionTargets(
        calories: 1840,
        proteinGrams: 155,
        carbsGrams: 170,
        fatGrams: 60,
      ),
      mealLog: [],
      region: 'Nigeria',
      suggestions: const [
        'Jollof rice with grilled chicken',
        'Beans and plantain with eggs',
        'Yogurt, fruit, and oats',
      ],
    );
  }

  int get consumedCalories =>
      mealLog.fold<int>(0, (sum, meal) => sum + meal.calories);

  int get consumedProteinGrams =>
      mealLog.fold<int>(0, (sum, meal) => sum + meal.proteinGrams);

  int get consumedCarbsGrams =>
      mealLog.fold<int>(0, (sum, meal) => sum + meal.carbsGrams);

  int get consumedFatGrams =>
      mealLog.fold<int>(0, (sum, meal) => sum + meal.fatGrams);

  int get remainingCalories => targets.calories - consumedCalories;

  int get remainingProteinGrams => targets.proteinGrams - consumedProteinGrams;

  double get calorieProgress =>
      targets.calories == 0 ? 0 : consumedCalories / targets.calories;

  NutritionState copyWith({
    NutritionTargets? targets,
    List<NutritionEntry>? mealLog,
    String? region,
    List<String>? suggestions,
  }) {
    return NutritionState(
      targets: targets ?? this.targets,
      mealLog: mealLog ?? this.mealLog,
      region: region ?? this.region,
      suggestions: suggestions ?? this.suggestions,
    );
  }
}
