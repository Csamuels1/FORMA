import '../../features/auth/domain/account_state.dart';
import '../../features/community/domain/community_state.dart';
import '../../features/nutrition/domain/nutrition_state.dart';
import '../../features/onboarding/domain/onboarding_state.dart';
import '../../features/notifications/domain/notification_preferences.dart';
import '../../features/progress/domain/progress_state.dart';
import '../../features/streaks/domain/streak_state.dart';
import '../../features/workout/domain/workout_session_state.dart';

class AppSeedRepository {
  const AppSeedRepository();

  OnboardingState onboardingState() => OnboardingState.initial();
  WorkoutSessionState workoutState() => WorkoutSessionState.initial();
  NutritionState nutritionState() => NutritionState.initial();
  NotificationPreferences notificationPreferences() => NotificationPreferences.initial();
  ProgressState progressState() => ProgressState.initial();
  StreakState streakState() => StreakState.initial();
  CommunityState communityState() => CommunityState.initial();
  AccountState accountState() => AccountState.initial();
}
