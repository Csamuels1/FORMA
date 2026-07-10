import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/app_seed_repository_provider.dart';
import '../domain/workout_session_state.dart';

final workoutSessionControllerProvider =
    StateNotifierProvider<WorkoutSessionController, WorkoutSessionState>(
  (ref) => WorkoutSessionController(ref.read(appSeedRepositoryProvider)),
);

class WorkoutSessionController extends StateNotifier<WorkoutSessionState> {
  WorkoutSessionController(this._seedRepository)
      : super(_seedRepository.workoutState());

  final AppSeedRepository _seedRepository;
  Timer? _restTimer;

  void completeCurrentSet() {
    if (state.isComplete) return;

    final exercise = state.currentExercise;
    final nextCompletedSets = state.completedSets + 1;
    final nextSetIndex = state.currentSetIndex + 1;
    final finishedExercise = nextSetIndex >= exercise.sets;
    final nextExerciseIndex = finishedExercise
        ? state.currentExerciseIndex + 1
        : state.currentExerciseIndex;

    final nextIsComplete = nextExerciseIndex >= state.exercises.length;
    final nextProgressionLevel = nextIsComplete ? state.progressionLevel + 1 : state.progressionLevel;

    state = state.copyWith(
      currentExerciseIndex: nextIsComplete
          ? state.currentExerciseIndex
          : nextExerciseIndex,
      currentSetIndex: nextIsComplete
          ? state.currentSetIndex
          : (finishedExercise ? 0 : nextSetIndex),
      completedSets: nextCompletedSets,
      isComplete: nextIsComplete,
      restSecondsRemaining: nextIsComplete ? 0 : exercise.restSeconds,
      progressionLevel: nextProgressionLevel,
    );

    if (nextIsComplete) {
      _cancelRestTimer();
    } else {
      _startRestTimer();
    }
  }

  void tickRestTimer() {
    if (state.restSecondsRemaining <= 0) return;
    state = state.copyWith(restSecondsRemaining: state.restSecondsRemaining - 1);
    if (state.restSecondsRemaining <= 0) {
      _cancelRestTimer();
    }
  }

  void skipRestTimer() {
    if (state.restSecondsRemaining <= 0) return;
    state = state.copyWith(restSecondsRemaining: 0);
    _cancelRestTimer();
  }

  void resetSession() {
    _cancelRestTimer();
    state = _seedRepository.workoutState();
  }

  void advanceProgression() {
    state = state.copyWith(progressionLevel: state.progressionLevel + 1);
  }

  void _startRestTimer() {
    _cancelRestTimer();
    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.restSecondsRemaining <= 0) {
        timer.cancel();
        return;
      }

      state = state.copyWith(restSecondsRemaining: state.restSecondsRemaining - 1);
      if (state.restSecondsRemaining <= 0) {
        timer.cancel();
      }
    });
  }

  void _cancelRestTimer() {
    _restTimer?.cancel();
    _restTimer = null;
  }

  @override
  void dispose() {
    _cancelRestTimer();
    super.dispose();
  }
}
