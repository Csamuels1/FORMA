import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../application/onboarding_controller.dart';
import 'onboarding_scaffold.dart';

class OnboardingRevealScreen extends ConsumerWidget {
  const OnboardingRevealScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);

    return OnboardingScaffold(
      title: 'Your plan is ready',
      body: 'This is where the generated workout and nutrition plan will be revealed.',
      primaryActionLabel: 'Enter app',
      onPrimaryAction: () => context.go('/home'),
      stepLabel: 'Reveal',
      stepProgress: 1,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SummaryTile(label: 'Goal', value: state.goal ?? 'Not set'),
          _SummaryTile(label: 'Environment', value: state.environment ?? 'Not set'),
          _SummaryTile(label: 'Consent', value: state.photoConsentAccepted ? 'Accepted' : 'Pending'),
          _SummaryTile(label: 'Photo', value: state.photoCaptured ? 'Captured' : 'Pending'),
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
