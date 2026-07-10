import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/forma_page_shell.dart';
import '../../../core/widgets/forma_section_card.dart';
import '../application/monetization_policy_provider.dart';
import '../domain/ad_guard.dart';
import '../domain/ad_placement.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final policy = ref.watch(monetizationPolicyProvider);
    final guard = AdGuard(policy);

    return FormaPageShell(
      appBar: AppBar(title: const Text('Subscription')),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;

          final proCard = FormaSectionCard(
            padding: const EdgeInsets.all(28),
            child: _TierCard(
              title: 'Pro',
              subtitle: 'Ads removed. More history. More control.',
              price: '\$8.99 / month',
              bullets: const [
                'Unlimited AI readjustments',
                'Full photo comparison history',
                'Streak freeze support',
              ],
              highlight: true,
            ),
          );

          final freeCard = FormaSectionCard(
            padding: const EdgeInsets.all(28),
            child: _TierCard(
              title: 'Free',
              subtitle: 'Full core experience with ad-supported placements.',
              price: 'Free',
              bullets: const [
                'Dashboard banner ads',
                'Feed banner ads',
                'Interstitials only between sessions',
              ],
            ),
          );

          final rulesCard = FormaSectionCard(
            padding: const EdgeInsets.all(28),
            child: _RulesCard(guard: guard),
          );

          if (wide) {
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: freeCard),
                    const SizedBox(width: 18),
                    Expanded(child: proCard),
                  ],
                ),
                const SizedBox(height: 18),
                rulesCard,
              ],
            );
          }

          return Column(
            children: [
              freeCard,
              const SizedBox(height: 18),
              proCard,
              const SizedBox(height: 18),
              rulesCard,
            ],
          );
        },
      ),
    );
  }
}

class _TierCard extends StatelessWidget {
  const _TierCard({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.bullets,
    this.highlight = false,
  });

  final String title;
  final String subtitle;
  final String price;
  final List<String> bullets;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: highlight
            ? Border.all(color: Theme.of(context).colorScheme.tertiary, width: 1.5)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          Text(price, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          ...bullets.map(
            (bullet) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check, size: 18),
                  const SizedBox(width: 10),
                  Expanded(child: Text(bullet)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RulesCard extends StatelessWidget {
  const _RulesCard({required this.guard});

  final AdGuard guard;

  @override
  Widget build(BuildContext context) {
    final placements = const [
      AdPlacement.dashboardBanner,
      AdPlacement.feedBanner,
      AdPlacement.betweenSessionsInterstitial,
      AdPlacement.blockedDuringSet,
      AdPlacement.blockedDuringRestTimer,
      AdPlacement.blockedDuringPhotoFlow,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ad guardrails', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        ...placements.map(
          (placement) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _RuleRow(
              label: placement.name,
              allowed: guard.canShow(placement),
            ),
          ),
        ),
      ],
    );
  }
}

class _RuleRow extends StatelessWidget {
  const _RuleRow({required this.label, required this.allowed});

  final String label;
  final bool allowed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          allowed ? Icons.check_circle : Icons.block,
          color: allowed ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.error,
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label)),
      ],
    );
  }
}
