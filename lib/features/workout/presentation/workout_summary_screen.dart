import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/forma_page_shell.dart';
import '../../../core/widgets/forma_section_card.dart';
import '../../streaks/application/streak_controller.dart';
import '../application/workout_session_controller.dart';
import '../domain/workout_session_state.dart';

class WorkoutSummaryScreen extends ConsumerWidget {
  const WorkoutSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(workoutSessionControllerProvider);
    final controller = ref.read(workoutSessionControllerProvider.notifier);
    final streakController = ref.read(streakControllerProvider.notifier);

    return FormaPageShell(
      appBar: AppBar(title: const Text('Session summary')),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;

          final detailsCard = FormaSectionCard(
            padding: const EdgeInsets.all(28),
            child: _SummaryDetails(session: session),
          );
          final actionCard = FormaSectionCard(
            padding: const EdgeInsets.all(28),
            child: _SummaryActions(
              onRestart: controller.resetSession,
              onBackHome: () => context.go('/home'),
              onStartAgain: () => context.go('/workout'),
              onMarkDayComplete: () {
                streakController.completeDay();
                context.go('/home');
              },
            ),
          );

          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 7, child: detailsCard),
                const SizedBox(width: 18),
                Expanded(flex: 5, child: actionCard),
              ],
            );
          }

          return Column(
            children: [
              detailsCard,
              const SizedBox(height: 18),
              actionCard,
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
    final stats = <_SummaryStat>[
      _SummaryStat(
          label: 'Plan', value: session.planName, detail: 'Today\'s session'),
      _SummaryStat(
        label: 'Sets complete',
        value: '${session.completedSets}/${session.totalSets}',
        detail: '${session.remainingSets} left to close the loop',
      ),
      _SummaryStat(
        label: 'Exercises done',
        value: '${session.completedExercises}/${session.totalExercises}',
        detail: session.currentExerciseLabel,
      ),
      _SummaryStat(
        label: 'Progression',
        value: 'Level ${session.progressionLevel}',
        detail: 'Ready for the next increment',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .primaryContainer
                .withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Workout complete',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              Text(
                'You finished the session with the important details captured. The next steps stay calm, clear, and low clutter.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 620;
            final crossAxisCount = wide ? 2 : 1;

            return GridView.count(
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: wide ? 2.2 : 3.1,
              children: stats
                  .map(
                    (stat) => _SummaryStatTile(stat: stat),
                  )
                  .toList(),
            );
          },
        ),
        const SizedBox(height: 20),
        FormaSectionCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('What this means',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Text(
                'The session is stored locally, the workout timer has been cleared, and the app is ready for the next structured run when you return.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: const [
                  Chip(label: Text('Saved offline')),
                  Chip(label: Text('Summary first')),
                  Chip(label: Text('Ads stay out of sets')),
                  Chip(label: Text('Ready for progression')),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryActions extends StatelessWidget {
  const _SummaryActions({
    required this.onRestart,
    required this.onBackHome,
    required this.onStartAgain,
    required this.onMarkDayComplete,
  });

  final VoidCallback onRestart;
  final VoidCallback onBackHome;
  final VoidCallback onStartAgain;
  final VoidCallback onMarkDayComplete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Next step', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        Text(
          'Choose the next move that fits your flow. We keep the handoff simple so recovery does not feel crowded.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: onStartAgain,
          child: const Text('Start another workout'),
        ),
        const SizedBox(height: 12),
        FilledButton.tonal(
          onPressed: onMarkDayComplete,
          child: const Text('Mark day complete'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: onBackHome,
          child: const Text('Back to home'),
        ),
        const SizedBox(height: 24),
        FormaSectionCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Reset option',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                'Use this if you want to clear the current session state and return to the baseline plan.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 14),
              FilledButton.tonal(
                onPressed: onRestart,
                child: const Text('Reset session'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryStat {
  const _SummaryStat({
    required this.label,
    required this.value,
    required this.detail,
  });

  final String label;
  final String value;
  final String detail;
}

class _SummaryStatTile extends StatelessWidget {
  const _SummaryStatTile({required this.stat});

  final _SummaryStat stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .outlineVariant
              .withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            stat.label,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 10),
          Text(
            stat.value,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 6),
          Text(
            stat.detail,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
