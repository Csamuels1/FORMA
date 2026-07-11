import '../../../core/models/nutrition_targets.dart';
import 'nutrition_entry.dart';

class NutritionState {
  const NutritionState({
    required this.goal,
    required this.targets,
    required this.mealLog,
    required this.region,
    required this.suggestions,
  });

  final String goal;
  final NutritionTargets targets;
  final List<NutritionEntry> mealLog;
  final String region;
  final List<String> suggestions;

  factory NutritionState.initial({
    String? goal,
    String region = 'Nigeria',
    NutritionTargets? targets,
    List<String>? suggestions,
  }) {
    return NutritionState(
      goal: goal ?? 'Lose fat',
      targets: targets ??
          const NutritionTargets(
            calories: 1840,
            proteinGrams: 155,
            carbsGrams: 170,
            fatGrams: 60,
          ),
      mealLog: const [],
      region: region,
      suggestions: suggestions ??
          const [
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

  Map<String, dynamic> toJson() {
    return {
      'goal': goal,
      'targets': {
        'calories': targets.calories,
        'proteinGrams': targets.proteinGrams,
        'carbsGrams': targets.carbsGrams,
        'fatGrams': targets.fatGrams,
      },
      'mealLog': mealLog.map((meal) => meal.toJson()).toList(),
      'region': region,
      'suggestions': suggestions,
    };
  }

  factory NutritionState.fromJson(Map<String, dynamic> json) {
    final seed = NutritionState.initial();
    final targetsJson = json['targets'];
    final mealLogJson = json['mealLog'];
    final suggestionsJson = json['suggestions'];

    return NutritionState(
      goal: json['goal'] as String? ?? seed.goal,
      targets: targetsJson is Map<String, dynamic>
          ? NutritionTargets(
              calories:
                  targetsJson['calories'] as int? ?? seed.targets.calories,
              proteinGrams: targetsJson['proteinGrams'] as int? ??
                  seed.targets.proteinGrams,
              carbsGrams:
                  targetsJson['carbsGrams'] as int? ?? seed.targets.carbsGrams,
              fatGrams:
                  targetsJson['fatGrams'] as int? ?? seed.targets.fatGrams,
            )
          : seed.targets,
      mealLog: mealLogJson is List
          ? mealLogJson
              .whereType<Map>()
              .map((item) =>
                  NutritionEntry.fromJson(item.cast<String, dynamic>()))
              .toList()
          : seed.mealLog,
      region: json['region'] as String? ?? seed.region,
      suggestions: suggestionsJson is List
          ? suggestionsJson.whereType<String>().toList()
          : seed.suggestions,
    );
  }

  NutritionState copyWith({
    String? goal,
    NutritionTargets? targets,
    List<NutritionEntry>? mealLog,
    String? region,
    List<String>? suggestions,
  }) {
    return NutritionState(
      goal: goal ?? this.goal,
      targets: targets ?? this.targets,
      mealLog: mealLog ?? this.mealLog,
      region: region ?? this.region,
      suggestions: suggestions ?? this.suggestions,
    );
  }
}
