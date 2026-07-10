import 'package:flutter/material.dart';

import '../../../core/widgets/forma_page_shell.dart';
import '../../../core/widgets/forma_section_card.dart';

class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    super.key,
    required this.title,
    required this.body,
    required this.primaryActionLabel,
    required this.onPrimaryAction,
    required this.stepLabel,
    required this.stepProgress,
    this.content,
  });

  final String title;
  final String body;
  final String primaryActionLabel;
  final VoidCallback onPrimaryAction;
  final String stepLabel;
  final double stepProgress;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    return FormaPageShell(
      appBar: AppBar(
        title: const Text('FORMA'),
        centerTitle: false,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 760;
          final contentWidth = wide ? 680.0 : double.infinity;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentWidth),
              child: FormaSectionCard(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Chip(label: Text(stepLabel)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              minHeight: 8,
                              value: stepProgress,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      body,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    if (content != null) ...[
                      const SizedBox(height: 24),
                      content!,
                    ],
                    const SizedBox(height: 28),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FilledButton(
                        onPressed: onPrimaryAction,
                        child: Text(primaryActionLabel),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
