class NotificationPreferences {
  const NotificationPreferences({
    required this.workoutReminders,
    required this.progressCheckIns,
    required this.streakWarnings,
    required this.lastUpdatedIso,
  });

  final bool workoutReminders;
  final bool progressCheckIns;
  final bool streakWarnings;
  final String? lastUpdatedIso;

  factory NotificationPreferences.initial() {
    return const NotificationPreferences(
      workoutReminders: true,
      progressCheckIns: true,
      streakWarnings: true,
      lastUpdatedIso: null,
    );
  }

  NotificationPreferences copyWith({
    bool? workoutReminders,
    bool? progressCheckIns,
    bool? streakWarnings,
    String? lastUpdatedIso,
  }) {
    return NotificationPreferences(
      workoutReminders: workoutReminders ?? this.workoutReminders,
      progressCheckIns: progressCheckIns ?? this.progressCheckIns,
      streakWarnings: streakWarnings ?? this.streakWarnings,
      lastUpdatedIso: lastUpdatedIso ?? this.lastUpdatedIso,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workoutReminders': workoutReminders,
      'progressCheckIns': progressCheckIns,
      'streakWarnings': streakWarnings,
      'lastUpdatedIso': lastUpdatedIso,
    };
  }

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    final seed = NotificationPreferences.initial();
    return NotificationPreferences(
      workoutReminders:
          json['workoutReminders'] as bool? ?? seed.workoutReminders,
      progressCheckIns:
          json['progressCheckIns'] as bool? ?? seed.progressCheckIns,
      streakWarnings: json['streakWarnings'] as bool? ?? seed.streakWarnings,
      lastUpdatedIso: json['lastUpdatedIso'] as String?,
    );
  }
}
