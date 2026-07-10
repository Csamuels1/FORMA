import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/app_seed_repository_provider.dart';
import '../domain/nutrition_state.dart';

final nutritionControllerProvider =
    StateNotifierProvider<NutritionController, NutritionState>(
  (ref) => NutritionController(ref.read(appSeedRepositoryProvider)),
);

class NutritionController extends StateNotifier<NutritionState> {
  NutritionController(this._seedRepository) : super(_seedRepository.nutritionState());

  final AppSeedRepository _seedRepository;

  void addMeal(String meal) {
    state = state.copyWith(mealLog: [...state.mealLog, meal]);
  }

  void setRegion(String region) {
    state = state.copyWith(
      region: region,
      suggestions: _suggestionsFor(region),
    );
  }

  List<String> _suggestionsFor(String region) {
    switch (region.toLowerCase()) {
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
