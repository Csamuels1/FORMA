import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/auth_entry_screen.dart';
import '../features/auth/presentation/account_settings_screen.dart';
import '../features/community/presentation/community_feed_screen.dart';
import '../features/home/presentation/home_shell_screen.dart';
import '../features/monetization/presentation/subscription_screen.dart';
import '../features/notifications/presentation/notifications_screen.dart';
import '../features/nutrition/presentation/nutrition_screen.dart';
import '../features/onboarding/presentation/onboarding_environment_screen.dart';
import '../features/onboarding/presentation/onboarding_goal_screen.dart';
import '../features/onboarding/presentation/onboarding_photo_screen.dart';
import '../features/onboarding/presentation/onboarding_reveal_screen.dart';
import '../features/onboarding/presentation/onboarding_stats_screen.dart';
import '../features/progress/presentation/progress_screen.dart';
import '../features/streaks/presentation/streaks_screen.dart';
import '../features/workout/presentation/daily_workout_screen.dart';
import '../features/workout/presentation/workout_summary_screen.dart';

final GoRouter formaRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthEntryScreen(),
    ),
    GoRoute(
      path: '/onboarding/goal',
      builder: (context, state) => const OnboardingGoalScreen(),
    ),
    GoRoute(
      path: '/onboarding/environment',
      builder: (context, state) => const OnboardingEnvironmentScreen(),
    ),
    GoRoute(
      path: '/onboarding/stats',
      builder: (context, state) => const OnboardingStatsScreen(),
    ),
    GoRoute(
      path: '/onboarding/photo',
      builder: (context, state) => const OnboardingPhotoScreen(),
    ),
    GoRoute(
      path: '/onboarding/reveal',
      builder: (context, state) => const OnboardingRevealScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeShellScreen(),
    ),
    GoRoute(
      path: '/workout',
      builder: (context, state) => const DailyWorkoutScreen(),
    ),
    GoRoute(
      path: '/workout/summary',
      builder: (context, state) => const WorkoutSummaryScreen(),
    ),
    GoRoute(
      path: '/nutrition',
      builder: (context, state) => const NutritionScreen(),
    ),
    GoRoute(
      path: '/progress',
      builder: (context, state) => const ProgressScreen(),
    ),
    GoRoute(
      path: '/streaks',
      builder: (context, state) => const StreaksScreen(),
    ),
    GoRoute(
      path: '/community',
      builder: (context, state) => const CommunityFeedScreen(),
    ),
    GoRoute(
      path: '/subscription',
      builder: (context, state) => const SubscriptionScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const AccountSettingsScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
  ],
);
