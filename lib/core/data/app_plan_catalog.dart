import '../models/exercise.dart';
import '../models/nutrition_targets.dart';
import '../models/workout_plan.dart';

class AppPlanCatalog {
  const AppPlanCatalog();

  WorkoutPlan workoutPlan({
    String? goal,
    String? environment,
  }) {
    final normalizedGoal = (goal ?? 'Lose fat').toLowerCase();
    final normalizedEnvironment = environment ?? 'Home only';

    switch (normalizedGoal) {
      case 'build strength':
        return WorkoutPlan(
          id: 'build-strength-home',
          goal: 'Build strength',
          environment: normalizedEnvironment,
          daysPerWeek: 4,
          exercises: const [
            Exercise(
                id: 'push-ups',
                name: 'Push-ups',
                sets: 4,
                reps: 10,
                restSeconds: 75),
            Exercise(
                id: 'split-squats',
                name: 'Split squats',
                sets: 4,
                reps: 10,
                restSeconds: 60),
            Exercise(
                id: 'pike-push-ups',
                name: 'Pike push-ups',
                sets: 3,
                reps: 8,
                restSeconds: 75),
            Exercise(
                id: 'glute-bridge',
                name: 'Glute bridge',
                sets: 3,
                reps: 15,
                restSeconds: 45),
          ],
        );
      case 'lose fat':
      default:
        return WorkoutPlan(
          id: 'lose-fat-home',
          goal: 'Lose fat',
          environment: normalizedEnvironment,
          daysPerWeek: 3,
          exercises: const [
            Exercise(
                id: 'push-ups',
                name: 'Push-ups',
                sets: 3,
                reps: 12,
                restSeconds: 60),
            Exercise(
                id: 'squats',
                name: 'Bodyweight squats',
                sets: 3,
                reps: 15,
                restSeconds: 45),
            Exercise(
                id: 'mountain-climbers',
                name: 'Mountain climbers',
                sets: 3,
                reps: 20,
                restSeconds: 45),
            Exercise(
                id: 'plank',
                name: 'Plank hold',
                sets: 3,
                reps: 1,
                restSeconds: 30),
          ],
        );
    }
  }

  NutritionTargets nutritionTargetsForGoal(String? goal) {
    switch ((goal ?? 'Lose fat').toLowerCase()) {
      case 'build strength':
        return const NutritionTargets(
          calories: 2200,
          proteinGrams: 175,
          carbsGrams: 225,
          fatGrams: 70,
        );
      case 'lose fat':
      default:
        return const NutritionTargets(
          calories: 1840,
          proteinGrams: 155,
          carbsGrams: 170,
          fatGrams: 60,
        );
    }
  }

  List<String> nutritionSuggestionsForGoalAndRegion({
    required String? goal,
    required String region,
  }) {
    final normalizedGoal = (goal ?? 'Lose fat').toLowerCase();
    final normalizedRegion = region.toLowerCase();

    if (normalizedGoal == 'build strength') {
      switch (normalizedRegion) {
        case 'nigeria':
          return const [
            'Jollof rice with grilled chicken',
            'Beans and plantain with eggs',
            'Yogurt, oats, and peanut butter',
          ];
        case 'kenya':
          return const [
            'Ugali with sukuma wiki and grilled chicken',
            'Githeri with avocado and eggs',
            'Fruit, yogurt, oats, and nuts',
          ];
        default:
          return const [
            'Rice bowl with grilled protein and vegetables',
            'Oats, yogurt, fruit, and nuts',
            'Bean bowl with extra chicken',
          ];
      }
    }

    switch (normalizedRegion) {
      case 'nigeria':
        return const [
          'Jollof rice with grilled chicken',
          'Beans and plantain with eggs',
          'Pepper soup with fish and vegetables',
        ];
      case 'kenya':
        return const [
          'Ugali with sukuma wiki and grilled chicken',
          'Githeri with avocado',
          'Fruit, yogurt, and oats',
        ];
      default:
        return const [
          'Grilled protein with rice and vegetables',
          'Eggs, oats, and fruit',
          'Bean bowl with greens',
        ];
    }
  }
}
