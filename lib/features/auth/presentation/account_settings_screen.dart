import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/forma_page_shell.dart';
import '../../../core/widgets/forma_section_card.dart';
import '../application/account_controller.dart';

class AccountSettingsScreen extends ConsumerWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(accountControllerProvider);
    final controller = ref.read(accountControllerProvider.notifier);

    return FormaPageShell(
      appBar: AppBar(title: const Text('Account settings')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FormaSectionCard(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(state.displayName, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 6),
                Text(state.email),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: const [
                    Chip(label: Text('Privacy-first')),
                    Chip(label: Text('Account control')),
                    Chip(label: Text('Deletion ready')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          FormaSectionCard(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Actions', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    controller.signIn();
                    context.go('/home');
                  },
                  child: Text(state.signedIn ? 'Refresh session' : 'Sign in'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    controller.signOut();
                    context.go('/');
                  },
                  child: const Text('Sign out'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
