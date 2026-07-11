class StreakState {
  const StreakState({
    required this.currentDays,
    required this.bestDays,
    required this.freezeBalance,
    required this.riskLevel,
    required this.lastCompletedDateIso,
  });

  final int currentDays;
  final int bestDays;
  final int freezeBalance;
  final String riskLevel;
  final String? lastCompletedDateIso;

  factory StreakState.initial() {
    return const StreakState(
      currentDays: 12,
      bestDays: 31,
      freezeBalance: 1,
      riskLevel: 'Stable',
      lastCompletedDateIso: null,
    );
  }

  StreakState copyWith({
    int? currentDays,
    int? bestDays,
    int? freezeBalance,
    String? riskLevel,
    String? lastCompletedDateIso,
  }) {
    return StreakState(
      currentDays: currentDays ?? this.currentDays,
      bestDays: bestDays ?? this.bestDays,
      freezeBalance: freezeBalance ?? this.freezeBalance,
      riskLevel: riskLevel ?? this.riskLevel,
      lastCompletedDateIso: lastCompletedDateIso ?? this.lastCompletedDateIso,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentDays': currentDays,
      'bestDays': bestDays,
      'freezeBalance': freezeBalance,
      'riskLevel': riskLevel,
      'lastCompletedDateIso': lastCompletedDateIso,
    };
  }

  factory StreakState.fromJson(Map<String, dynamic> json) {
    final seed = StreakState.initial();
    return StreakState(
      currentDays: json['currentDays'] as int? ?? seed.currentDays,
      bestDays: json['bestDays'] as int? ?? seed.bestDays,
      freezeBalance: json['freezeBalance'] as int? ?? seed.freezeBalance,
      riskLevel: json['riskLevel'] as String? ?? seed.riskLevel,
      lastCompletedDateIso: json['lastCompletedDateIso'] as String?,
    );
  }
}
