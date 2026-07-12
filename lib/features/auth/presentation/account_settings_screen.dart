import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/photo_policy_provider.dart';
import '../../../core/models/photo_policy.dart';
import '../../../core/widgets/forma_page_shell.dart';
import '../../../core/widgets/forma_section_card.dart';
import '../../community/application/community_controller.dart';
import '../../notifications/application/notification_preferences_controller.dart';
import '../../onboarding/application/onboarding_controller.dart';
import '../../nutrition/application/nutrition_controller.dart';
import '../../progress/application/progress_controller.dart';
import '../../streaks/application/streak_controller.dart';
import '../../workout/application/workout_session_controller.dart';
import '../application/account_controller.dart';

class AccountSettingsScreen extends ConsumerWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(accountControllerProvider);
    final controller = ref.read(accountControllerProvider.notifier);
    final onboardingController =
        ref.read(onboardingControllerProvider.notifier);
    final workoutController =
        ref.read(workoutSessionControllerProvider.notifier);
    final nutritionController = ref.read(nutritionControllerProvider.notifier);
    final progressController = ref.read(progressControllerProvider.notifier);
    final streakController = ref.read(streakControllerProvider.notifier);
    final communityController = ref.read(communityControllerProvider.notifier);
    final notificationController =
        ref.read(notificationPreferencesProvider.notifier);
    final photoPolicy = ref.watch(photoPolicyProvider);

    return FormaPageShell(
      appBar: AppBar(title: const Text('Account settings')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FormaSectionCard(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(state.displayName,
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 6),
                Text(state.email),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: const [
                    Chip(label: Text('Privacy-first')),
                    Chip(label: Text('Account control')),
                    Chip(label: Text('Deletion ready')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          FormaSectionCard(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Account deletion',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 12),
                Text(
                  'This removes local app state for workouts, nutrition, progress, streaks, community, notifications, and photo consent. '
                  'It also signs you out immediately.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                FilledButton.tonalIcon(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          title: const Text('Delete account and data?'),
                          content: const Text(
                            'This will clear local app state and sign you out. '
                            'This action cannot be undone from the device.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(false),
                              child: const Text('Cancel'),
                            ),
                            FilledButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(true),
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirm != true || !context.mounted) {
                      return;
                    }

                    onboardingController.clearPhotoFlow();
                    workoutController.resetSession();
                    nutritionController.resetMeals();
                    progressController.clearProgressData();
                    streakController.clearStreakData();
                    communityController.clearCommunityData();
                    notificationController.clearPreferences();
                    controller.deleteAccount();
                    context.go('/');
                  },
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Delete account and data'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          FormaSectionCard(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Photo privacy',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 12),
                Text(
                  _policySummary(photoPolicy),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    FilledButton.tonal(
                      onPressed: () {
                        onboardingController.clearPhotoFlow();
                        progressController.clearPhotoCheckIns();
                      },
                      child: const Text('Delete photo data'),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        onboardingController.clearPhotoFlow();
                        progressController.clearPhotoCheckIns();
                      },
                      child: const Text('Reset photo consent'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          FormaSectionCard(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Actions',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    controller.signIn();
                    context.go('/home');
                  },
                  child: Text(state.signedIn ? 'Refresh session' : 'Sign in'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    controller.signOut();
                    context.go('/');
                  },
                  child: const Text('Sign out'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _policySummary(PhotoPolicy policy) {
    return 'Photos stay ${_storageText(policy.storageMode)} and are analyzed ${_analysisText(policy.analysisMode)}. '
        'Retention is ${policy.retentionDays} days, and consent is required before capture.';
  }

  String _storageText(PhotoStorageMode mode) {
    switch (mode) {
      case PhotoStorageMode.localOnly:
        return 'on-device only';
      case PhotoStorageMode.cloud:
        return 'in the cloud';
      case PhotoStorageMode.hybrid:
        return 'locally and in the cloud';
    }
  }

  String _analysisText(PhotoAnalysisMode mode) {
    switch (mode) {
      case PhotoAnalysisMode.onDevice:
        return 'on-device';
      case PhotoAnalysisMode.cloudApi:
        return 'via cloud API';
      case PhotoAnalysisMode.hybrid:
        return 'via both device and cloud';
    }
  }
}
