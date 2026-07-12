import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/app_seed_repository_provider.dart';
import '../data/streak_storage.dart';
import '../data/streak_storage_provider.dart';
import '../domain/streak_state.dart';

final streakControllerProvider =
    StateNotifierProvider<StreakController, StreakState>(
  (ref) {
    final storage = ref.read(streakStorageProvider);
    final controller = StreakController(
      ref.read(appSeedRepositoryProvider),
      storage,
    );
    unawaited(storage.restore().then(controller.hydrateFromStorage));
    return controller;
  },
);

class StreakController extends StateNotifier<StreakState> {
  StreakController(this._seedRepository, this._storage)
      : super(_seedRepository.streakState());

  final AppSeedRepository _seedRepository;
  final StreakStorage _storage;

  void hydrateFromStorage(StreakState? restored) {
    if (restored == null) return;
    state = restored;
  }

  void completeDay({DateTime? now}) {
    final today = _dayKey(now ?? DateTime.now());
    if (state.lastCompletedDateIso == today) return;

    final nextDays = state.currentDays + 1;
    state = state.copyWith(
      currentDays: nextDays,
      bestDays: nextDays > state.bestDays ? nextDays : state.bestDays,
      riskLevel: _riskFor(nextDays, state.freezeBalance),
      lastCompletedDateIso: today,
    );
    unawaited(_storage.save(state));
  }

  void useFreeze() {
    if (state.freezeBalance <= 0) return;
    final nextBalance = state.freezeBalance - 1;
    state = state.copyWith(
      freezeBalance: nextBalance,
      riskLevel: _riskFor(state.currentDays, nextBalance),
    );
    unawaited(_storage.save(state));
  }

  void resetStreak() {
    state = _seedRepository.streakState();
    unawaited(_storage.clear());
  }

  void clearStreakData() {
    state = const StreakState(
      currentDays: 0,
      bestDays: 0,
      freezeBalance: 0,
      riskLevel: 'Reset',
      lastCompletedDateIso: null,
    );
    unawaited(_storage.clear());
  }

  String _riskFor(int days, int freezeBalance) {
    if (freezeBalance <= 0 && days < 7) {
      return 'Fragile';
    }
    if (days < 7) {
      return 'Building';
    }
    if (days < 21) {
      return 'Stable';
    }
    return 'Strong';
  }

  String _dayKey(DateTime date) {
    final local = date.toLocal();
    final normalized = DateTime(local.year, local.month, local.day);
    return normalized.toIso8601String();
  }
}
