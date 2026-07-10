import '../../../core/models/nutrition_targets.dart';

class NutritionState {
  const NutritionState({
    required this.targets,
    required this.mealLog,
    required this.region,
    required this.suggestions,
  });

  final NutritionTargets targets;
  final List<String> mealLog;
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

  NutritionState copyWith({
    NutritionTargets? targets,
    List<String>? mealLog,
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
