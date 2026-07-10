import 'exercise.dart';

class WorkoutPlan {
  const WorkoutPlan({
    required this.id,
    required this.goal,
    required this.environment,
    required this.daysPerWeek,
    required this.exercises,
  });

  final String id;
  final String goal;
  final String environment;
  final int daysPerWeek;
  final List<Exercise> exercises;
}
