import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/photo_policy_provider.dart';
import '../../../core/models/photo_policy.dart';
import '../../../core/widgets/forma_section_card.dart';
import '../application/onboarding_controller.dart';
import 'onboarding_scaffold.dart';

class OnboardingPhotoScreen extends ConsumerWidget {
  const OnboardingPhotoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);
    final policy = ref.watch(photoPolicyProvider);

    return OnboardingScaffold(
      title: 'Capture a photo',
      body:
          'We keep the MVP photo flow local-first, on-device, and explicit about consent before capture.',
      primaryActionLabel: 'Next',
      onPrimaryAction: () => context.go('/onboarding/reveal'),
      stepLabel: 'Step 4 of 4',
      stepProgress: 1,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PolicyCard(policy: policy),
          const SizedBox(height: 16),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: state.photoConsentAccepted,
            onChanged: (value) => controller.setPhotoConsent(value ?? false),
            title: const Text('I agree to photo capture for progress tracking'),
            subtitle: const Text(
              'Consent is required before analysis or storage. Photos stay local in this MVP.',
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.tonal(
            onPressed: state.photoConsentAccepted
                ? () => controller.setPhotoCaptured(true)
                : null,
            child:
                Text(state.photoCaptured ? 'Photo captured' : 'Capture photo'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: controller.clearPhotoFlow,
            child: const Text('Clear photo consent'),
          ),
        ],
      ),
    );
  }
}

class _PolicyCard extends StatelessWidget {
  const _PolicyCard({required this.policy});

  final PhotoPolicy policy;

  @override
  Widget build(BuildContext context) {
    return FormaSectionCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Photo privacy', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          Text(
            _storageText(policy.storageMode),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 6),
          Text(
            _analysisText(policy.analysisMode),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 6),
          Text(
            'Retention: ${policy.retentionDays} days before local cleanup.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 6),
          Text(
            policy.requiresConsentBeforeCapture
                ? 'Consent is required before capture.'
                : 'Consent is optional for capture.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  String _storageText(PhotoStorageMode mode) {
    switch (mode) {
      case PhotoStorageMode.localOnly:
        return 'Storage: local device only for the MVP.';
      case PhotoStorageMode.cloud:
        return 'Storage: cloud-backed.';
      case PhotoStorageMode.hybrid:
        return 'Storage: hybrid local + cloud.';
    }
  }

  String _analysisText(PhotoAnalysisMode mode) {
    switch (mode) {
      case PhotoAnalysisMode.onDevice:
        return 'Analysis: on-device only.';
      case PhotoAnalysisMode.cloudApi:
        return 'Analysis: cloud API.';
      case PhotoAnalysisMode.hybrid:
        return 'Analysis: hybrid local + cloud.';
    }
  }
}
