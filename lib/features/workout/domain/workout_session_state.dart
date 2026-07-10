import '../../../core/models/exercise.dart';

class WorkoutSessionState {
  const WorkoutSessionState({
    required this.planName,
    required this.exercises,
    required this.currentExerciseIndex,
    required this.currentSetIndex,
    required this.completedSets,
    required this.isComplete,
    required this.restSecondsRemaining,
    required this.progressionLevel,
  });

  final String planName;
  final List<Exercise> exercises;
  final int currentExerciseIndex;
  final int currentSetIndex;
  final int completedSets;
  final bool isComplete;
  final int restSecondsRemaining;
  final int progressionLevel;

  factory WorkoutSessionState.initial() {
    return WorkoutSessionState(
      planName: 'Full body strength',
      exercises: const [
        Exercise(
            id: 'push-ups',
            name: 'Push-ups',
            sets: 3,
            reps: 12,
            restSeconds: 60),
        Exercise(
            id: 'squats',
            name: 'Bodyweight squats',
            sets: 3,
            reps: 15,
            restSeconds: 45),
        Exercise(
            id: 'plank', name: 'Plank hold', sets: 3, reps: 1, restSeconds: 30),
      ],
      currentExerciseIndex: 0,
      currentSetIndex: 0,
      completedSets: 0,
      isComplete: false,
      restSecondsRemaining: 0,
      progressionLevel: 1,
    );
  }

  Exercise get currentExercise => exercises[currentExerciseIndex];

  int get totalSets =>
      exercises.fold<int>(0, (sum, exercise) => sum + exercise.sets);

  int get remainingSets => totalSets - completedSets;

  int get totalExercises => exercises.length;

  int get completedExercises {
    if (isComplete) {
      return totalExercises;
    }

    final fullyCompletedExercises = currentExerciseIndex;
    return fullyCompletedExercises.clamp(0, totalExercises).toInt();
  }

  int get remainingExercises => totalExercises - completedExercises;

  String get currentSetLabel {
    if (isComplete) {
      return 'Session complete';
    }

    return 'Set ${currentSetIndex + 1} of ${currentExercise.sets}';
  }

  String get currentExerciseLabel {
    if (isComplete) {
      return 'Workout finished';
    }

    return currentExercise.name;
  }

  double get progress => totalSets == 0 ? 0 : completedSets / totalSets;

  WorkoutSessionState copyWith({
    String? planName,
    List<Exercise>? exercises,
    int? currentExerciseIndex,
    int? currentSetIndex,
    int? completedSets,
    bool? isComplete,
    int? restSecondsRemaining,
    int? progressionLevel,
  }) {
    return WorkoutSessionState(
      planName: planName ?? this.planName,
      exercises: exercises ?? this.exercises,
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      currentSetIndex: currentSetIndex ?? this.currentSetIndex,
      completedSets: completedSets ?? this.completedSets,
      isComplete: isComplete ?? this.isComplete,
      restSecondsRemaining: restSecondsRemaining ?? this.restSecondsRemaining,
      progressionLevel: progressionLevel ?? this.progressionLevel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'planName': planName,
      'currentExerciseIndex': currentExerciseIndex,
      'currentSetIndex': currentSetIndex,
      'completedSets': completedSets,
      'isComplete': isComplete,
      'restSecondsRemaining': restSecondsRemaining,
      'progressionLevel': progressionLevel,
    };
  }

  factory WorkoutSessionState.fromJson(Map<String, dynamic> json) {
    final seed = WorkoutSessionState.initial();
    return seed.copyWith(
      planName: json['planName'] as String? ?? seed.planName,
      currentExerciseIndex:
          json['currentExerciseIndex'] as int? ?? seed.currentExerciseIndex,
      currentSetIndex: json['currentSetIndex'] as int? ?? seed.currentSetIndex,
      completedSets: json['completedSets'] as int? ?? seed.completedSets,
      isComplete: json['isComplete'] as bool? ?? seed.isComplete,
      restSecondsRemaining:
          json['restSecondsRemaining'] as int? ?? seed.restSecondsRemaining,
      progressionLevel:
          json['progressionLevel'] as int? ?? seed.progressionLevel,
    );
  }
}
