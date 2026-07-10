class NotificationPreferences {
  const NotificationPreferences({
    required this.workoutReminders,
    required this.progressCheckIns,
    required this.streakWarnings,
  });

  final bool workoutReminders;
  final bool progressCheckIns;
  final bool streakWarnings;

  factory NotificationPreferences.initial() {
    return const NotificationPreferences(
      workoutReminders: true,
      progressCheckIns: true,
      streakWarnings: true,
    );
  }

  NotificationPreferences copyWith({
    bool? workoutReminders,
    bool? progressCheckIns,
    bool? streakWarnings,
  }) {
    return NotificationPreferences(
      workoutReminders: workoutReminders ?? this.workoutReminders,
      progressCheckIns: progressCheckIns ?? this.progressCheckIns,
      streakWarnings: streakWarnings ?? this.streakWarnings,
    );
  }
}
