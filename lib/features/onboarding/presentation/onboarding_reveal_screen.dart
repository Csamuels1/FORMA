import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/app_seed_repository_provider.dart';
import '../application/onboarding_controller.dart';
import 'onboarding_scaffold.dart';

class OnboardingRevealScreen extends ConsumerWidget {
  const OnboardingRevealScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final repository = ref.read(appSeedRepositoryProvider);
    final workoutPreview = repository.workoutState(
      goal: state.goal,
      environment: state.environment,
    );
    final nutritionPreview = repository.nutritionState(goal: state.goal);

    return OnboardingScaffold(
      title: 'Your plan is ready',
      body:
          'This plan is generated from your selected goal and the home-only MVP rules. It stays rule-based for now, not AI-generated.',
      primaryActionLabel: 'Enter app',
      onPrimaryAction: () => context.go('/home'),
      stepLabel: 'Reveal',
      stepProgress: 1,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SummaryTile(label: 'Goal', value: state.goal ?? 'Not set'),
          _SummaryTile(
              label: 'Environment', value: state.environment ?? 'Not set'),
          _SummaryTile(
            label: 'Workout plan',
            value:
                '${workoutPreview.planName} · ${workoutPreview.exercises.length} moves · ${workoutPreview.totalSets} sets',
          ),
          _SummaryTile(
            label: 'Nutrition target',
            value:
                '${nutritionPreview.targets.calories} kcal · ${nutritionPreview.targets.proteinGrams}g protein',
          ),
          _SummaryTile(
            label: 'Top meal pick',
            value: nutritionPreview.suggestions.first,
          ),
          _SummaryTile(
            label: 'Consent',
            value: state.photoConsentAccepted ? 'Accepted' : 'Pending',
          ),
          _SummaryTile(
            label: 'Photo',
            value: state.photoCaptured ? 'Captured' : 'Pending',
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.titleMedium),
          ),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
