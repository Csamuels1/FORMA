class ProgressState {
  const ProgressState({
    required this.currentWeightKg,
    required this.weightHistory,
    required this.photoCheckIns,
  });

  final double currentWeightKg;
  final List<double> weightHistory;
  final List<String> photoCheckIns;

  factory ProgressState.initial() {
    return const ProgressState(
      currentWeightKg: 94.0,
      weightHistory: [97.2, 95.4, 94.0],
      photoCheckIns: ['Jan check-in', 'Feb check-in'],
    );
  }

  ProgressState copyWith({
    double? currentWeightKg,
    List<double>? weightHistory,
    List<String>? photoCheckIns,
  }) {
    return ProgressState(
      currentWeightKg: currentWeightKg ?? this.currentWeightKg,
      weightHistory: weightHistory ?? this.weightHistory,
      photoCheckIns: photoCheckIns ?? this.photoCheckIns,
    );
  }
}
