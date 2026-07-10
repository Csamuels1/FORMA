import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/app_seed_repository_provider.dart';
import '../domain/streak_state.dart';

final streakControllerProvider =
    StateNotifierProvider<StreakController, StreakState>(
  (ref) => StreakController(ref.read(appSeedRepositoryProvider)),
);

class StreakController extends StateNotifier<StreakState> {
  StreakController(this._seedRepository) : super(_seedRepository.streakState());

  final AppSeedRepository _seedRepository;

  void completeDay() {
    final nextDays = state.currentDays + 1;
    state = state.copyWith(
      currentDays: nextDays,
      bestDays: nextDays > state.bestDays ? nextDays : state.bestDays,
    );
  }

  void useFreeze() {
    if (state.freezeBalance <= 0) return;
    state = state.copyWith(freezeBalance: state.freezeBalance - 1);
  }
}
