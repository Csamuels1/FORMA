class StreakState {
  const StreakState({
    required this.currentDays,
    required this.bestDays,
    required this.freezeBalance,
    required this.riskLevel,
  });

  final int currentDays;
  final int bestDays;
  final int freezeBalance;
  final String riskLevel;

  factory StreakState.initial() {
    return const StreakState(
      currentDays: 12,
      bestDays: 31,
      freezeBalance: 1,
      riskLevel: 'Stable',
    );
  }

  StreakState copyWith({
    int? currentDays,
    int? bestDays,
    int? freezeBalance,
    String? riskLevel,
  }) {
    return StreakState(
      currentDays: currentDays ?? this.currentDays,
      bestDays: bestDays ?? this.bestDays,
      freezeBalance: freezeBalance ?? this.freezeBalance,
      riskLevel: riskLevel ?? this.riskLevel,
    );
  }
}
