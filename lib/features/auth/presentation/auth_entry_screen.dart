import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/forma_page_shell.dart';
import '../../../core/widgets/forma_section_card.dart';

class AuthEntryScreen extends StatelessWidget {
  const AuthEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FormaPageShell(
      appBar: AppBar(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 920;
          final hero = _HeroPanel(onStart: () => context.go('/onboarding/goal'));
          final details = _DetailsPanel(onSkip: () => context.go('/home'));

          if (wide) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: hero),
                  const SizedBox(width: 24),
                  Expanded(flex: 4, child: details),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                hero,
                const SizedBox(height: 20),
                details,
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return FormaSectionCard(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text('Home fitness without clutter'),
          ),
          const SizedBox(height: 20),
          Text(
            'FORMA',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 14),
          Text(
            'Your body. Your goal. Your plan. Every day.',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'Built for a home-only wedge first. Clean, private, and structured around the actual work of getting lean without a gym.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _StatChip(label: 'Private photo flow'),
              _StatChip(label: 'Home-only MVP'),
              _StatChip(label: 'Progress tracking'),
            ],
          ),
          const SizedBox(height: 28),
          FilledButton(
            onPressed: onStart,
            child: const Text('Start onboarding'),
          ),
        ],
      ),
    );
  }
}

class _DetailsPanel extends StatelessWidget {
  const _DetailsPanel({required this.onSkip});

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return FormaSectionCard(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'What you will get',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          const _FeatureRow(
            title: 'Guided onboarding',
            body: 'Goal, environment, stats, and photo consent in a clear sequence.',
          ),
          const SizedBox(height: 12),
          const _FeatureRow(
            title: 'Daily workout loop',
            body: 'Workout, rest, finish, and review without interface noise.',
          ),
          const SizedBox(height: 12),
          const _FeatureRow(
            title: 'Progress and streaks',
            body: 'See what changed and keep the chain visible.',
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: onSkip,
            child: const Text('Skip to shell'),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(body, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label));
  }
}
