import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../application/onboarding_controller.dart';
import 'onboarding_scaffold.dart';

class OnboardingGoalScreen extends ConsumerWidget {
  const OnboardingGoalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGoal = ref.watch(onboardingControllerProvider).goal;
    final controller = ref.read(onboardingControllerProvider.notifier);

    return OnboardingScaffold(
      title: 'Select your goal',
      body: 'Choose the starting point that best matches what you want to fix first.',
      primaryActionLabel: 'Next',
      onPrimaryAction: () => context.go('/onboarding/environment'),
      stepLabel: 'Step 1 of 4',
      stepProgress: 0.25,
      content: Column(
        children: [
          _ChoiceCard(
            label: 'Lose fat',
            selected: selectedGoal == 'Lose fat',
            onTap: () => controller.selectGoal('Lose fat'),
          ),
          const SizedBox(height: 12),
          _ChoiceCard(
            label: 'Build strength',
            selected: selectedGoal == 'Build strength',
            onTap: () => controller.selectGoal('Build strength'),
          ),
        ],
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(label),
        trailing: Icon(
          selected ? Icons.check_circle : Icons.radio_button_unchecked,
          color: selected ? Theme.of(context).colorScheme.tertiary : null,
        ),
      ),
    );
  }
}
