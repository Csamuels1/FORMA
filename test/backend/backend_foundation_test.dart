import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:forma/core/backend/backend_policy_snapshot.dart';
import 'package:forma/core/backend/backend_repository_provider.dart';
import 'package:forma/core/backend/backend_schema.dart';
import 'package:forma/core/backend/backend_session_controller.dart';
import 'package:forma/core/models/photo_policy.dart';
import 'package:forma/features/auth/application/account_controller.dart';

void main() {
  test('backend policy snapshot maps to monetization and photo policies', () {
    const snapshot = BackendPolicySnapshot(
      freeTierAiReadjustmentDays: 21,
      proStreakFreezePerMonth: 2,
      allowDashboardBannerAds: false,
      allowFeedBannerAds: true,
      allowBetweenSessionInterstitials: false,
      photoRetentionDays: 45,
      photoStorageMode: PhotoStorageMode.hybrid,
      photoAnalysisMode: PhotoAnalysisMode.onDevice,
      requiresPhotoConsentBeforeCapture: true,
    );

    final monetization = snapshot.toMonetizationPolicy();
    final photoPolicy = snapshot.toPhotoPolicy();

    expect(monetization.freeTierAiReadjustmentDays, 21);
    expect(monetization.proStreakFreezePerMonth, 2);
    expect(monetization.allowDashboardBannerAds, false);
    expect(photoPolicy.storageMode, PhotoStorageMode.hybrid);
    expect(photoPolicy.retentionDays, 45);
    expect(photoPolicy.analysisMode, PhotoAnalysisMode.onDevice);
  });

  test('backend records round-trip through json', () {
    final workoutPlan = BackendWorkoutPlanRecord(
      id: 'plan-1',
      userId: 'user-1',
      goal: 'Lose fat',
      environment: 'Home only',
      daysPerWeek: 3,
      progressionRules: const {'weeklyIncrease': 1},
      exercises: const [
        BackendExerciseRecord(
          id: 'push-ups',
          planId: 'plan-1',
          name: 'Push-ups',
          sets: 3,
          reps: 12,
          restSeconds: 60,
          demoUrl: null,
        ),
      ],
    );

    final json = workoutPlan.toJson();
    final restored = BackendWorkoutPlanRecord.fromJson(json);

    expect(restored.id, workoutPlan.id);
    expect(restored.exercises.single.name, 'Push-ups');
    expect(restored.progressionRules['weeklyIncrease'], 1);
  });

  test('backend session bootstrap and sign in keep local-first flow intact',
      () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final repo = container.read(backendRepositoryProvider);
    final session = await repo.bootstrapSession();
    expect(session.signedIn, false);

    final controller =
        container.read(backendSessionControllerProvider.notifier);
    await controller.signIn(
      displayName: 'FORMA Athlete',
      email: 'athlete@forma.app',
      locale: 'en_NG',
      region: 'Nigeria',
      tier: 'free',
    );

    final storedSession = container.read(backendSessionControllerProvider);
    expect(storedSession.signedIn, true);
    expect(storedSession.email, 'athlete@forma.app');

    final accountController =
        container.read(accountControllerProvider.notifier);
    accountController.signOut();
    await Future<void>.delayed(Duration.zero);

    expect(container.read(backendSessionControllerProvider).signedIn, false);
  });
}
