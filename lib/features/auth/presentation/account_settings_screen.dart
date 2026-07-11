import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/photo_policy_provider.dart';
import '../../../core/models/photo_policy.dart';
import '../../../core/widgets/forma_page_shell.dart';
import '../../../core/widgets/forma_section_card.dart';
import '../../onboarding/application/onboarding_controller.dart';
import '../../progress/application/progress_controller.dart';
import '../application/account_controller.dart';

class AccountSettingsScreen extends ConsumerWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(accountControllerProvider);
    final controller = ref.read(accountControllerProvider.notifier);
    final onboardingController =
        ref.read(onboardingControllerProvider.notifier);
    final progressController = ref.read(progressControllerProvider.notifier);
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
