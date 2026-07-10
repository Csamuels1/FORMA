import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/forma_section_card.dart';

class HomeShellScreen extends StatefulWidget {
  const HomeShellScreen({super.key});

  @override
  State<HomeShellScreen> createState() => _HomeShellScreenState();
}

class _HomeShellScreenState extends State<HomeShellScreen> {
  int _selectedIndex = 0;

  static const _destinations = [
    _ShellDestination('Home', Icons.dashboard_outlined, Icons.dashboard),
    _ShellDestination('Workout', Icons.fitness_center_outlined, Icons.fitness_center),
    _ShellDestination('Nutrition', Icons.restaurant_outlined, Icons.restaurant),
    _ShellDestination('Progress', Icons.insights_outlined, Icons.insights),
    _ShellDestination('Community', Icons.forum_outlined, Icons.forum),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 980;
        final body = _shellBody(context);

        if (wide) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('FORMA'),
              actions: [
                IconButton(
                  onPressed: () => context.go('/notifications'),
                  icon: const Icon(Icons.notifications_none),
                ),
                IconButton(
                  onPressed: () => context.go('/settings'),
                  icon: const Icon(Icons.settings_outlined),
                ),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    NavigationRail(
                      selectedIndex: _selectedIndex,
                      onDestinationSelected: (value) {
                        setState(() => _selectedIndex = value);
                      },
                      labelType: NavigationRailLabelType.all,
                      leading: Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Column(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.fitness_center, color: Colors.white),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'FORMA',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                      destinations: _destinations
                          .map(
                            (destination) => NavigationRailDestination(
                              icon: Icon(destination.icon),
                              selectedIcon: Icon(destination.selectedIcon),
                              label: Text(destination.label),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: body,
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => context.go('/workout'),
              child: const Icon(Icons.play_arrow),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('FORMA'),
            actions: [
              IconButton(
                onPressed: () => context.go('/notifications'),
                icon: const Icon(Icons.notifications_none),
              ),
              IconButton(
                onPressed: () => context.go('/settings'),
                icon: const Icon(Icons.settings_outlined),
              ),
            ],
          ),
          body: SafeArea(child: body),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (value) => setState(() => _selectedIndex = value),
            destinations: _destinations
                .map(
                  (destination) => NavigationDestination(
                    icon: Icon(destination.icon),
                    selectedIcon: Icon(destination.selectedIcon),
                    label: destination.label,
                  ),
                )
                .toList(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => context.go('/workout'),
            child: const Icon(Icons.play_arrow),
          ),
        );
      },
    );
  }

  Widget _shellBody(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: _selectedIndex == 0
          ? _DashboardView(key: const ValueKey('dashboard'))
          : _SectionPlaceholder(
              key: ValueKey(_selectedIndex),
              title: _destinations[_selectedIndex].label,
              message: 'This section shell will be fleshed out in the next module pass.',
              primaryActionLabel: _selectedIndex == 1 ? 'Open workout' : 'Continue',
              onPrimaryAction: () => context.go('/workout'),
            ),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _HeroBanner(onStart: () => context.go('/workout')),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 720;
              final crossAxisCount = wide ? 2 : 1;

              return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: wide ? 2.2 : 2.9,
                children: const [
                  _SummaryCard(
                    title: 'Workout today',
                    value: 'Upper body + core',
                    detail: '36 min',
                  ),
                  _SummaryCard(
                    title: 'Streak',
                    value: '12 days',
                    detail: 'One more to hit the next marker',
                  ),
                  _SummaryCard(
                    title: 'Nutrition',
                    value: '1,840 kcal',
                    detail: '620 kcal remaining',
                  ),
                  _SummaryCard(
                    title: 'Progress',
                    value: '-4.2 lb',
                    detail: 'Since last check-in',
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 900;
              if (wide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(child: _DashboardListCard()),
                    SizedBox(width: 16),
                    Expanded(child: _DashboardListCard(secondary: true)),
                  ],
                );
              }

              return const Column(
                children: [
                  _DashboardListCard(),
                  SizedBox(height: 16),
                  _DashboardListCard(secondary: true),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return FormaSectionCard(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today is lined up.',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'A clean daily plan, no clutter, and no guesswork. Start the session when you are ready.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              Chip(label: Text('Active set tracking')),
              Chip(label: Text('Rest timers')),
              Chip(label: Text('Photo-safe gating')),
            ],
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: onStart,
            child: const Text('Start workout'),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.detail,
  });

  final String title;
  final String value;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return FormaSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          Text(value, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 6),
          Text(detail, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _DashboardListCard extends StatelessWidget {
  const _DashboardListCard({this.secondary = false});

  final bool secondary;

  @override
  Widget build(BuildContext context) {
    final items = secondary
        ? const [
            _ListItem(title: 'Photo check-in', detail: 'Monthly comparison window'),
            _ListItem(title: 'Community', detail: 'A few fresh posts from the feed'),
            _ListItem(title: 'Free tier', detail: 'Ad placements stay outside workout flow'),
          ]
        : const [
            _ListItem(title: 'Warm-up', detail: '7 minutes'),
            _ListItem(title: 'Main work', detail: '4 movements, 3 rounds'),
            _ListItem(title: 'Cooldown', detail: 'Breathing and mobility'),
          ];

    return FormaSectionCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            secondary ? 'Supporting actions' : 'Session outline',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ...items.expand(
            (item) => [
              _ListTile(item: item),
              const SizedBox(height: 12),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionPlaceholder extends StatelessWidget {
  const _SectionPlaceholder({
    super.key,
    required this.title,
    required this.message,
    required this.primaryActionLabel,
    required this.onPrimaryAction,
  });

  final String title;
  final String message;
  final String primaryActionLabel;
  final VoidCallback onPrimaryAction;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: FormaSectionCard(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            Text(message, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: const [
                Chip(label: Text('Responsive shell')),
                Chip(label: Text('Intentional spacing')),
                Chip(label: Text('Feature-first')),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: onPrimaryAction,
              child: Text(primaryActionLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  const _ListTile({required this.item});

  final _ListItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(item.detail, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _ListItem {
  const _ListItem({required this.title, required this.detail});

  final String title;
  final String detail;
}

class _ShellDestination {
  const _ShellDestination(this.label, this.icon, this.selectedIcon);

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
