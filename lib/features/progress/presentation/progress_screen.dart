import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/forma_page_shell.dart';
import '../../../core/widgets/forma_section_card.dart';
import '../application/progress_controller.dart';
import '../domain/progress_entry.dart';
import '../domain/progress_state.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(progressControllerProvider);
    final controller = ref.read(progressControllerProvider.notifier);

    return FormaPageShell(
      appBar: AppBar(title: const Text('Progress')),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;

          final overview = FormaSectionCard(
            padding: const EdgeInsets.all(28),
            child: _ProgressOverview(state: state),
          );
          final timeline = FormaSectionCard(
            padding: const EdgeInsets.all(28),
            child: _ProgressTimeline(
              state: state,
              onAddSample: () => controller.addWeightSample(93.5),
              onAddCheckIn: () => controller.addPhotoCheckIn('March check-in'),
            ),
          );

          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: overview),
                const SizedBox(width: 18),
                Expanded(flex: 6, child: timeline),
              ],
            );
          }

          return Column(
            children: [
              overview,
              const SizedBox(height: 18),
              timeline,
            ],
          );
        },
      ),
    );
  }
}

class _ProgressOverview extends StatelessWidget {
  const _ProgressOverview({required this.state});

  final ProgressState state;

  @override
  Widget build(BuildContext context) {
    final totalEntries = state.entries.length;

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
              Text('Progress summary',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              Text(
                'Track your body trend, your monthly photo check-ins, and the history that ties it together.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _ProgressMetric(
          label: 'Current weight',
          value: '${state.currentWeightKg.toStringAsFixed(1)} kg',
          detail:
              '${state.weightChangeKg.toStringAsFixed(1)} kg from the starting sample',
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 640;
            final crossAxisCount = wide ? 2 : 1;

            return GridView.count(
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: wide ? 2.35 : 3.0,
              children: [
                _SmallStat(
                    label: 'Weight samples',
                    value: '${state.weightSampleCount}'),
                _SmallStat(
                    label: 'Photo check-ins',
                    value: '${state.photoCheckInCount}'),
                _SmallStat(label: 'History items', value: '$totalEntries'),
                _SmallStat(
                    label: 'Trend',
                    value: state.weightChangeKg >= 0 ? 'Down' : 'Up'),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        FormaSectionCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Cadence', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              const _CadenceItem(
                title: 'Weight',
                detail:
                    'Add a measurement whenever you have a consistent morning weigh-in.',
              ),
              const SizedBox(height: 10),
              const _CadenceItem(
                title: 'Photos',
                detail:
                    'Use monthly front, side, and back check-ins for visual comparison.',
              ),
              const SizedBox(height: 10),
              const _CadenceItem(
                title: 'Review',
                detail:
                    'Compare the latest entries before the next plan update.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProgressTimeline extends StatelessWidget {
  const _ProgressTimeline({
    required this.state,
    required this.onAddSample,
    required this.onAddCheckIn,
  });

  final ProgressState state;
  final VoidCallback onAddSample;
  final VoidCallback onAddCheckIn;

  @override
  Widget build(BuildContext context) {
    final entries = state.entries.reversed.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('History', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        Text(
          'A clean timeline keeps the history readable without turning the screen into a wall of data.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 18),
        ...entries
            .map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _EntryCard(entry: entry),
              ),
            )
            .toList(),
        const SizedBox(height: 18),
        FormaSectionCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quick actions',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: onAddSample,
                      child: const Text('Add weight sample'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onAddCheckIn,
                      child: const Text('Add photo check-in'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({required this.entry});

  final ProgressEntry entry;

  @override
  Widget build(BuildContext context) {
    final icon = entry.kind == ProgressEntryKind.weight
        ? Icons.monitor_weight_outlined
        : Icons.photo_camera_outlined;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.label,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(entry.detail,
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressMetric extends StatelessWidget {
  const _ProgressMetric({
    required this.label,
    required this.value,
    required this.detail,
  });

  final String label;
  final String value;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return FormaSectionCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(detail, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _SmallStat extends StatelessWidget {
  const _SmallStat({required this.label, required this.value});

  final String label;
  final String value;

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
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}

class _CadenceItem extends StatelessWidget {
  const _CadenceItem({
    required this.title,
    required this.detail,
  });

  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.circle,
            size: 10, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 10),
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
    );
  }
}
