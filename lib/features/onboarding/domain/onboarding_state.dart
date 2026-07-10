class OnboardingState {
  const OnboardingState({
    required this.goal,
    required this.environment,
    required this.heightCm,
    required this.weightKg,
    required this.ageYears,
    required this.photoConsentAccepted,
    required this.photoCaptured,
  });

  final String? goal;
  final String? environment;
  final int? heightCm;
  final int? weightKg;
  final int? ageYears;
  final bool photoConsentAccepted;
  final bool photoCaptured;

  factory OnboardingState.initial() {
    return const OnboardingState(
      goal: null,
      environment: 'Home only',
      heightCm: null,
      weightKg: null,
      ageYears: null,
      photoConsentAccepted: false,
      photoCaptured: false,
    );
  }

  OnboardingState copyWith({
    String? goal,
    String? environment,
    int? heightCm,
    int? weightKg,
    int? ageYears,
    bool? photoConsentAccepted,
    bool? photoCaptured,
  }) {
    return OnboardingState(
      goal: goal ?? this.goal,
      environment: environment ?? this.environment,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      ageYears: ageYears ?? this.ageYears,
      photoConsentAccepted: photoConsentAccepted ?? this.photoConsentAccepted,
      photoCaptured: photoCaptured ?? this.photoCaptured,
    );
  }
}
