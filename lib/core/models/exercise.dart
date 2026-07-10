class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.sets,
    required this.reps,
    required this.restSeconds,
    this.demoUrl,
  });

  final String id;
  final String name;
  final int sets;
  final int reps;
  final int restSeconds;
  final String? demoUrl;
}
