import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/app_seed_repository_provider.dart';
import '../data/notification_preferences_storage.dart';
import '../data/notification_preferences_storage_provider.dart';
import '../domain/notification_preferences.dart';

final notificationPreferencesProvider = StateNotifierProvider<
    NotificationPreferencesController, NotificationPreferences>(
  (ref) {
    final storage = ref.read(notificationPreferencesStorageProvider);
    final controller = NotificationPreferencesController(
      ref.read(appSeedRepositoryProvider),
      storage,
    );
    unawaited(storage.restore().then(controller.hydrateFromStorage));
    return controller;
  },
);

class NotificationPreferencesController
    extends StateNotifier<NotificationPreferences> {
  NotificationPreferencesController(this._seedRepository, this._storage)
      : super(_seedRepository.notificationPreferences());

  final AppSeedRepository _seedRepository;
  final NotificationPreferencesStorage _storage;

  void hydrateFromStorage(NotificationPreferences? restored) {
    if (restored == null) return;
    state = restored;
  }

  void toggleWorkoutReminders() {
    state = state.copyWith(
      workoutReminders: !state.workoutReminders,
      lastUpdatedIso: DateTime.now().toIso8601String(),
    );
    unawaited(_storage.save(state));
  }

  void toggleProgressCheckIns() {
    state = state.copyWith(
      progressCheckIns: !state.progressCheckIns,
      lastUpdatedIso: DateTime.now().toIso8601String(),
    );
    unawaited(_storage.save(state));
  }

  void toggleStreakWarnings() {
    state = state.copyWith(
      streakWarnings: !state.streakWarnings,
      lastUpdatedIso: DateTime.now().toIso8601String(),
    );
    unawaited(_storage.save(state));
  }

  void resetPreferences() {
    state = _seedRepository.notificationPreferences();
    unawaited(_storage.clear());
  }

  void clearPreferences() {
    state = const NotificationPreferences(
      workoutReminders: false,
      progressCheckIns: false,
      streakWarnings: false,
      lastUpdatedIso: null,
    );
    unawaited(_storage.save(state));
  }
}
