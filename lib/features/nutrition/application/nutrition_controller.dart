import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/app_seed_repository_provider.dart';
import '../data/nutrition_storage.dart';
import '../data/nutrition_storage_provider.dart';
import '../domain/nutrition_entry.dart';
import '../domain/nutrition_state.dart';
import '../../onboarding/application/onboarding_controller.dart';

final nutritionControllerProvider =
    StateNotifierProvider<NutritionController, NutritionState>(
  (ref) {
    final storage = ref.read(nutritionStorageProvider);
    final onboarding = ref.read(onboardingControllerProvider);
    final controller = NutritionController(
      ref.read(appSeedRepositoryProvider),
      storage,
      onboarding.goal,
    );
    unawaited(storage.restore().then(controller.hydrateFromStorage));
    return controller;
  },
);

class NutritionController extends StateNotifier<NutritionState> {
  NutritionController(
    this._seedRepository,
    this._storage,
    this._selectedGoal,
  ) : super(
          _seedRepository.nutritionState(
            goal: _selectedGoal,
            region: 'Nigeria',
          ),
        );

  final AppSeedRepository _seedRepository;
  final NutritionStorage _storage;
  final String? _selectedGoal;

  void hydrateFromStorage(NutritionState? restored) {
    if (restored == null) return;
    state = restored;
  }

  void addMeal(String meal) {
    state = state.copyWith(
      mealLog: [...state.mealLog, _entryFor(meal, state.region)],
    );
    unawaited(_storage.save(state));
  }

  void setRegion(String region) {
    state = state.copyWith(
      region: region,
      suggestions: _suggestionsFor(state.goal, region),
    );
    unawaited(_storage.save(state));
  }

  void resetMeals() {
    state = _seedRepository.nutritionState(
      goal: state.goal,
      region: state.region,
    );
    unawaited(_storage.clear());
  }

  List<String> _suggestionsFor(String goal, String region) {
    return _seedRepository
        .nutritionState(goal: goal, region: region)
        .suggestions;
  }

  NutritionEntry _entryFor(String meal, String region) {
    switch (meal) {
      case 'Chicken, rice, and vegetables':
        return const NutritionEntry(
          label: 'Chicken, rice, and vegetables',
          calories: 620,
          proteinGrams: 42,
          carbsGrams: 58,
          fatGrams: 18,
          note: 'Balanced recovery plate',
        );
      case 'Jollof rice with grilled chicken':
        return const NutritionEntry(
          label: 'Jollof rice with grilled chicken',
          calories: 680,
          proteinGrams: 40,
          carbsGrams: 66,
          fatGrams: 21,
          note: 'Region-aware recommendation',
        );
      case 'Beans and plantain with eggs':
        return const NutritionEntry(
          label: 'Beans and plantain with eggs',
          calories: 590,
          proteinGrams: 28,
          carbsGrams: 72,
          fatGrams: 17,
          note: 'High-fiber meal option',
        );
      case 'Pepper soup with fish and vegetables':
        return const NutritionEntry(
          label: 'Pepper soup with fish and vegetables',
          calories: 410,
          proteinGrams: 35,
          carbsGrams: 18,
          fatGrams: 14,
          note: 'Lighter recovery meal',
        );
      case 'Ugali with sukuma wiki and grilled chicken':
        return const NutritionEntry(
          label: 'Ugali with sukuma wiki and grilled chicken',
          calories: 640,
          proteinGrams: 41,
          carbsGrams: 61,
          fatGrams: 20,
          note: 'Region-aware recommendation',
        );
      case 'Githeri with avocado':
        return const NutritionEntry(
          label: 'Githeri with avocado',
          calories: 560,
          proteinGrams: 23,
          carbsGrams: 69,
          fatGrams: 19,
          note: 'Steady-energy meal',
        );
      case 'Fruit, yogurt, and oats':
      case 'Yogurt, fruit, and oats':
        return const NutritionEntry(
          label: 'Yogurt, fruit, and oats',
          calories: 380,
          proteinGrams: 21,
          carbsGrams: 48,
          fatGrams: 10,
          note: 'Quick breakfast or snack',
        );
      case 'Eggs, oats, and fruit':
        return const NutritionEntry(
          label: 'Eggs, oats, and fruit',
          calories: 430,
          proteinGrams: 27,
          carbsGrams: 41,
          fatGrams: 15,
          note: 'Morning-friendly option',
        );
      case 'Bean bowl with greens':
        return const NutritionEntry(
          label: 'Bean bowl with greens',
          calories: 470,
          proteinGrams: 24,
          carbsGrams: 52,
          fatGrams: 14,
          note: 'Simple plant-forward plate',
        );
      default:
        return NutritionEntry(
          label: meal,
          calories: region.toLowerCase() == 'nigeria' ? 600 : 560,
          proteinGrams: 30,
          carbsGrams: 55,
          fatGrams: 18,
          note: 'Estimated meal log',
        );
    }
  }
}
