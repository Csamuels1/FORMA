import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/forma_page_shell.dart';
import '../../../core/widgets/forma_section_card.dart';
import '../application/workout_session_controller.dart';
import '../domain/workout_session_state.dart';

class WorkoutSummaryScreen extends ConsumerWidget {
  const WorkoutSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(workoutSessionControllerProvider);
    final controller = ref.read(workoutSessionControllerProvider.notifier);

    return FormaPageShell(
      appBar: AppBar(title: const Text('Session summary')),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;

          final summaryCard = FormaSectionCard(
            padding: const EdgeInsets.all(28),
            child: _SummaryDetails(session: session),
          );
          final actionsCard = FormaSectionCard(
            padding: const EdgeInsets.all(28),
            child: _SummaryActions(
              onRestart: controller.resetSession,
              onBackHome: () => context.go('/home'),
            ),
          );

          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: summaryCard),
                const SizedBox(width: 18),
                Expanded(child: actionsCard),
              ],
            );
          }

          return Column(
            children: [
              summaryCard,
              const SizedBox(height: 18),
              actionsCard,
            ],
          );
        },
      ),
    );
  }
}

class _SummaryDetails extends StatelessWidget {
  const _SummaryDetails({required this.session});

  final WorkoutSessionState session;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Workout complete', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        Text(
          'Great work. The next screen can eventually show progress streak updates and an interstitial, but only in approved placements.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 20),
        _MetricRow(label: 'Session', value: session.planName),
        _MetricRow(label: 'Sets completed', value: '${session.completedSets}/${session.totalSets}'),
        _MetricRow(label: 'Progression level', value: '${session.progressionLevel}'),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
            Chip(label: Text('Between-session ad safe')),
            Chip(label: Text('Summary first')),
            Chip(label: Text('Ready for streak update')),
          ],
        ),
      ],
    );
  }
}

class _SummaryActions extends StatelessWidget {
  const _SummaryActions({
    required this.onRestart,
    required this.onBackHome,
  });

  final VoidCallback onRestart;
  final VoidCallback onBackHome;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Next step', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        const Text('Review the session, then move back into the shell.'),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: onRestart,
          child: const Text('Reset workout'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: onBackHome,
          child: const Text('Back to home'),
        ),
      ],
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
