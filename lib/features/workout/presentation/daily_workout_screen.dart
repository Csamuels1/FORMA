import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/forma_page_shell.dart';
import '../../../core/widgets/forma_section_card.dart';
import '../application/workout_session_controller.dart';
import '../domain/workout_session_state.dart';

class DailyWorkoutScreen extends ConsumerWidget {
  const DailyWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(workoutSessionControllerProvider);
    final controller = ref.read(workoutSessionControllerProvider.notifier);

    return FormaPageShell(
      appBar: AppBar(
        title: const Text('Workout session'),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;

          final overview = _WorkoutOverview(session: session);
          final exercisePanel = _ExercisePanel(
            session: session,
            onCompleteSet: controller.completeCurrentSet,
            onSkipRest: controller.skipRestTimer,
            onReset: controller.resetSession,
          );

          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: overview),
                const SizedBox(width: 18),
                Expanded(flex: 6, child: exercisePanel),
              ],
            );
          }

          return Column(
            children: [
              overview,
              const SizedBox(height: 18),
              exercisePanel,
            ],
          );
        },
      ),
    );
  }
}

class _WorkoutOverview extends StatelessWidget {
  const _WorkoutOverview({required this.session});

  final WorkoutSessionState session;

  @override
  Widget build(BuildContext context) {
    return FormaSectionCard(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Today\'s plan', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 10),
          Text(
            session.planName,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(value: session.progress, minHeight: 10),
          ),
          const SizedBox(height: 12),
          Text(
            '${session.completedSets} of ${session.totalSets} sets complete',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 6),
          Text(
            'Progression level ${session.progressionLevel}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              Chip(label: Text('Offline safe')),
              Chip(label: Text('Between-session ads only')),
              Chip(label: Text('No clutter during sets')),
              Chip(label: Text('Progressive overload')),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExercisePanel extends StatelessWidget {
  const _ExercisePanel({
    required this.session,
    required this.onCompleteSet,
    required this.onSkipRest,
    required this.onReset,
  });

  final WorkoutSessionState session;
  final VoidCallback onCompleteSet;
  final VoidCallback onSkipRest;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    if (session.isComplete) {
          return FormaSectionCard(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Session complete', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            Text(
              'Workout finished. Move to the summary screen to review the session.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.go('/workout/summary'),
              child: const Text('View summary'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onReset,
              child: const Text('Reset session'),
            ),
          ],
        ),
      );
    }

    final exercise = session.currentExercise;

    return FormaSectionCard(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Current exercise', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          Text(exercise.name, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          Text(
            'Set ${session.currentSetIndex + 1} of ${exercise.sets} - ${exercise.reps} reps - ${exercise.restSeconds}s rest',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          if (session.restSecondsRemaining > 0) ...[
            Text(
              'Rest in progress: ${session.restSecondsRemaining}s remaining',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 14),
          ],
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: onCompleteSet,
                  child: const Text('Complete set'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: session.restSecondsRemaining > 0 ? onSkipRest : null,
                  child: Text(
                    session.restSecondsRemaining > 0
                        ? 'Skip rest'
                        : 'No rest pending',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const _ExerciseTimeline(),
        ],
      ),
    );
  }
}

class _ExerciseTimeline extends StatelessWidget {
  const _ExerciseTimeline();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Session flow', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        const _TimelineStep(title: 'Warm-up', detail: 'Prepare joints and heart rate'),
        const _TimelineStep(title: 'Main work', detail: 'Three exercises, paced and tracked'),
        const _TimelineStep(title: 'Cool-down', detail: 'Lower intensity and recover'),
      ],
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({required this.title, required this.detail});

  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(detail, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
