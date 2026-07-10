import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../application/onboarding_controller.dart';
import 'onboarding_scaffold.dart';

class OnboardingPhotoScreen extends ConsumerWidget {
  const OnboardingPhotoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    return OnboardingScaffold(
      title: 'Capture a photo',
      body: 'We will show consent clearly before any analysis or storage rules.',
      primaryActionLabel: 'Next',
      onPrimaryAction: () => context.go('/onboarding/reveal'),
      stepLabel: 'Step 4 of 4',
      stepProgress: 1,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: state.photoConsentAccepted,
            onChanged: (value) => controller.setPhotoConsent(value ?? false),
            title: const Text('I agree to photo capture for progress tracking'),
            subtitle: const Text('Consent is required before analysis or storage.'),
          ),
          const SizedBox(height: 8),
          FilledButton.tonal(
            onPressed: state.photoConsentAccepted
                ? () => controller.setPhotoCaptured(true)
                : null,
            child: Text(state.photoCaptured ? 'Photo captured' : 'Capture photo'),
          ),
        ],
      ),
    );
  }
}
