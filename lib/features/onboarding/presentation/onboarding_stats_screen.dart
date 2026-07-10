import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../application/onboarding_controller.dart';
import 'onboarding_scaffold.dart';

class OnboardingStatsScreen extends ConsumerWidget {
  const OnboardingStatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    return OnboardingScaffold(
      title: 'Enter your stats',
      body: 'We will use your inputs to shape the plan and progress tracking.',
      primaryActionLabel: 'Next',
      onPrimaryAction: () => context.go('/onboarding/photo'),
      stepLabel: 'Step 3 of 4',
      stepProgress: 0.75,
      content: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _StatChip(
            label: 'Age 34',
            selected: state.ageYears == 34,
            onTap: () => controller.updateStats(ageYears: 34),
          ),
          _StatChip(
            label: 'Height 178 cm',
            selected: state.heightCm == 178,
            onTap: () => controller.updateStats(heightCm: 178),
          ),
          _StatChip(
            label: 'Weight 94 kg',
            selected: state.weightKg == 94,
            onTap: () => controller.updateStats(weightKg: 94),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      avatar: Icon(
        selected ? Icons.check_circle : Icons.tune,
        size: 18,
        color: selected ? Theme.of(context).colorScheme.tertiary : null,
      ),
    );
  }
}
