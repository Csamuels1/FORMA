import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/forma_page_shell.dart';
import '../../../core/widgets/forma_section_card.dart';
import '../application/streak_controller.dart';
import '../domain/streak_state.dart';

class StreaksScreen extends ConsumerWidget {
  const StreaksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(streakControllerProvider);
    final controller = ref.read(streakControllerProvider.notifier);

    return FormaPageShell(
      appBar: AppBar(title: const Text('Streaks')),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 800;

          final summary = FormaSectionCard(
            padding: const EdgeInsets.all(28),
            child: _StreakSummary(state: state),
          );
          final actions = FormaSectionCard(
            padding: const EdgeInsets.all(28),
            child: _StreakActions(
              state: state,
              onCompleteDay: () => controller.completeDay(),
              onUseFreeze: () => controller.useFreeze(),
            ),
          );

          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: summary),
                const SizedBox(width: 18),
                Expanded(child: actions),
              ],
            );
          }

          return Column(
            children: [
              summary,
              const SizedBox(height: 18),
              actions,
            ],
          );
        },
      ),
    );
  }
}

class _StreakSummary extends StatelessWidget {
  const _StreakSummary({required this.state});

  final StreakState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Current streak',
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        Text('${state.currentDays} days',
            style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: 10),
        Text('Best streak: ${state.bestDays} days'),
        const SizedBox(height: 10),
        Text('Freeze balance: ${state.freezeBalance}'),
        const SizedBox(height: 10),
        Text(
          'Last completed: ${state.lastCompletedDateIso ?? 'Not recorded yet'}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
            Chip(label: Text('Milestones')),
            Chip(label: Text('Freeze ready')),
            Chip(label: Text('Simple and clear')),
          ],
        ),
      ],
    );
  }
}

class _StreakActions extends StatelessWidget {
  const _StreakActions({
    required this.state,
    required this.onCompleteDay,
    required this.onUseFreeze,
  });

  final StreakState state;
  final VoidCallback onCompleteDay;
  final VoidCallback onUseFreeze;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Actions', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        Text('Risk level: ${state.riskLevel}'),
        const SizedBox(height: 18),
        FilledButton(
          onPressed: onCompleteDay,
          child: const Text('Mark day complete'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: state.freezeBalance > 0 ? onUseFreeze : null,
          child: const Text('Use streak freeze'),
        ),
      ],
    );
  }
}
