import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/forma_page_shell.dart';
import '../../../core/widgets/forma_section_card.dart';
import '../application/notification_preferences_controller.dart';
import '../domain/notification_preferences.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(notificationPreferencesProvider);
    final controller = ref.read(notificationPreferencesProvider.notifier);

    return FormaPageShell(
      appBar: AppBar(title: const Text('Notifications')),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;

          final prefsCard = FormaSectionCard(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reminders',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 12),
                Text(
                  'Keep the app useful without over-notifying. Workout, progress, and streak reminders can be controlled individually.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 18),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: prefs.workoutReminders,
                  onChanged: (_) => controller.toggleWorkoutReminders(),
                  title: const Text('Workout reminders'),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: prefs.progressCheckIns,
                  onChanged: (_) => controller.toggleProgressCheckIns(),
                  title: const Text('Progress check-ins'),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: prefs.streakWarnings,
                  onChanged: (_) => controller.toggleStreakWarnings(),
                  title: const Text('Streak warnings'),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: const [
                    Chip(label: Text('Private')),
                    Chip(label: Text('User-controlled')),
                    Chip(label: Text('Low noise')),
                  ],
                ),
              ],
            ),
          );

          final summaryCard = FormaSectionCard(
            padding: const EdgeInsets.all(28),
            child: _NotificationSummary(
                prefs: prefs, onReset: controller.resetPreferences),
          );

          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 7, child: prefsCard),
                const SizedBox(width: 18),
                Expanded(flex: 4, child: summaryCard),
              ],
            );
          }

          return Column(
            children: [
              prefsCard,
              const SizedBox(height: 18),
              summaryCard,
            ],
          );
        },
      ),
    );
  }
}

class _NotificationSummary extends StatelessWidget {
  const _NotificationSummary({
    required this.prefs,
    required this.onReset,
  });

  final NotificationPreferences prefs;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final enabledCount = [
      prefs.workoutReminders,
      prefs.progressCheckIns,
      prefs.streakWarnings,
    ].where((enabled) => enabled).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Summary', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        Text(
          '$enabledCount of 3 reminder types are enabled.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 12),
        Text(
          prefs.lastUpdatedIso == null
              ? 'No changes have been saved yet.'
              : 'Last updated ${prefs.lastUpdatedIso}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        FilledButton.tonal(
          onPressed: onReset,
          child: const Text('Reset reminders'),
        ),
      ],
    );
  }
}
