import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../application/onboarding_controller.dart';
import 'onboarding_scaffold.dart';

class OnboardingEnvironmentScreen extends ConsumerWidget {
  const OnboardingEnvironmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    return OnboardingScaffold(
      title: 'Choose environment',
      body: 'Home-only is the MVP wedge. That constraint keeps the plan focused.',
      primaryActionLabel: 'Next',
      onPrimaryAction: () => context.go('/onboarding/stats'),
      stepLabel: 'Step 2 of 4',
      stepProgress: 0.5,
      content: Column(
        children: [
          _ChoiceCard(
            label: 'Home only',
            selected: state.environment == 'Home only',
            subtitle: 'This is the MVP path.',
            onTap: () => controller.selectEnvironment('Home only'),
          ),
          const SizedBox(height: 12),
          _ChoiceCard(
            label: 'Gym later',
            selected: state.environment == 'Gym later',
            subtitle: 'Not part of MVP.',
            onTap: () => controller.selectEnvironment('Gym later'),
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
    required this.subtitle,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(label),
        subtitle: Text(subtitle),
        trailing: Icon(
          selected ? Icons.check_circle : Icons.radio_button_unchecked,
          color: selected ? Theme.of(context).colorScheme.tertiary : null,
        ),
      ),
    );
  }
}
