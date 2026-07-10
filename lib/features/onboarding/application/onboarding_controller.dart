import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/app_seed_repository_provider.dart';
import '../domain/onboarding_state.dart';

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>(
  (ref) => OnboardingController(ref.read(appSeedRepositoryProvider)),
);

class OnboardingController extends StateNotifier<OnboardingState> {
  OnboardingController(this._seedRepository) : super(_seedRepository.onboardingState());

  final AppSeedRepository _seedRepository;

  void selectGoal(String goal) {
    state = state.copyWith(goal: goal);
  }

  void selectEnvironment(String environment) {
    state = state.copyWith(environment: environment);
  }

  void updateStats({
    int? heightCm,
    int? weightKg,
    int? ageYears,
  }) {
    state = state.copyWith(
      heightCm: heightCm,
      weightKg: weightKg,
      ageYears: ageYears,
    );
  }

  void setPhotoConsent(bool accepted) {
    state = state.copyWith(photoConsentAccepted: accepted);
  }

  void setPhotoCaptured(bool captured) {
    state = state.copyWith(photoCaptured: captured);
  }
}
