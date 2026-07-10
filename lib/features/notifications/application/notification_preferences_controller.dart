import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/app_seed_repository_provider.dart';
import '../domain/notification_preferences.dart';

final notificationPreferencesProvider =
    StateNotifierProvider<NotificationPreferencesController, NotificationPreferences>(
  (ref) => NotificationPreferencesController(ref.read(appSeedRepositoryProvider)),
);

class NotificationPreferencesController extends StateNotifier<NotificationPreferences> {
  NotificationPreferencesController(this._seedRepository)
      : super(_seedRepository.notificationPreferences());

  final AppSeedRepository _seedRepository;

  void toggleWorkoutReminders() {
    state = state.copyWith(workoutReminders: !state.workoutReminders);
  }

  void toggleProgressCheckIns() {
    state = state.copyWith(progressCheckIns: !state.progressCheckIns);
  }

  void toggleStreakWarnings() {
    state = state.copyWith(streakWarnings: !state.streakWarnings);
  }
}
