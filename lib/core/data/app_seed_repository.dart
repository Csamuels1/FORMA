import '../../features/auth/domain/account_state.dart';
import '../../features/community/domain/community_state.dart';
import '../../features/nutrition/domain/nutrition_state.dart';
import '../../features/onboarding/domain/onboarding_state.dart';
import '../../features/notifications/domain/notification_preferences.dart';
import '../../features/progress/domain/progress_state.dart';
import '../../features/streaks/domain/streak_state.dart';
import '../../features/workout/domain/workout_session_state.dart';
import 'app_plan_catalog.dart';

class AppSeedRepository {
  const AppSeedRepository();

  static const _planCatalog = AppPlanCatalog();

  OnboardingState onboardingState() => OnboardingState.initial();
  WorkoutSessionState workoutState({
    String? goal,
    String? environment,
  }) =>
      WorkoutSessionState.fromPlan(
        _planCatalog.workoutPlan(goal: goal, environment: environment),
      );
  NutritionState nutritionState({
    String? goal,
    String region = 'Nigeria',
  }) =>
      NutritionState.initial(
        goal: goal,
        region: region,
        targets: _planCatalog.nutritionTargetsForGoal(goal),
        suggestions: _planCatalog.nutritionSuggestionsForGoalAndRegion(
          goal: goal,
          region: region,
        ),
      );
  NotificationPreferences notificationPreferences() =>
      NotificationPreferences.initial();
  ProgressState progressState() => ProgressState.initial();
  StreakState streakState() => StreakState.initial();
  CommunityState communityState() => CommunityState.initial();
  AccountState accountState() => AccountState.initial();
}
