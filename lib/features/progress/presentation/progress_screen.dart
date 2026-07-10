import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/forma_page_shell.dart';
import '../../../core/widgets/forma_section_card.dart';
import '../application/progress_controller.dart';
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
          final summary = FormaSectionCard(
            padding: const EdgeInsets.all(28),
            child: _ProgressSummary(state: state),
          );
          final history = FormaSectionCard(
            padding: const EdgeInsets.all(28),
            child: _ProgressHistory(
              state: state,
              onAddSample: () => controller.addWeightSample(93.5),
              onAddCheckIn: () => controller.addPhotoCheckIn('Mar check-in'),
            ),
          );

          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: summary),
                const SizedBox(width: 18),
                Expanded(child: history),
              ],
            );
          }

          return Column(
            children: [
              summary,
              const SizedBox(height: 18),
              history,
            ],
          );
        },
      ),
    );
  }
}

class _ProgressSummary extends StatelessWidget {
  const _ProgressSummary({required this.state});

  final ProgressState state;

  @override
  Widget build(BuildContext context) {
    final totalChange = state.weightHistory.isNotEmpty
        ? state.weightHistory.first - state.currentWeightKg
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Progress summary', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        Text(
          'Current weight: ${state.currentWeightKg.toStringAsFixed(1)} kg',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 20),
        _MetricRow(label: 'Net change', value: '${totalChange.toStringAsFixed(1)} kg'),
        _MetricRow(label: 'Weight samples', value: '${state.weightHistory.length}'),
        _MetricRow(label: 'Photo check-ins', value: '${state.photoCheckIns.length}'),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
            Chip(label: Text('Before / after')),
            Chip(label: Text('Monthly cadence')),
            Chip(label: Text('History ready')),
          ],
        ),
      ],
    );
  }
}

class _ProgressHistory extends StatelessWidget {
  const _ProgressHistory({
    required this.state,
    required this.onAddSample,
    required this.onAddCheckIn,
  });

  final ProgressState state;
  final VoidCallback onAddSample;
  final VoidCallback onAddCheckIn;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('History', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        Text('Photo check-ins', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        ...state.photoCheckIns.map(
          (checkIn) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text('- $checkIn'),
          ),
        ),
        const SizedBox(height: 16),
        Text('Weight trend', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: state.weightHistory
              .map((value) => Chip(label: Text('${value.toStringAsFixed(1)} kg')))
              .toList(),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: onAddSample,
                child: const Text('Add sample'),
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
      padding: const EdgeInsets.only(bottom: 12),
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
