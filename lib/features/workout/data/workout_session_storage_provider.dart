import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'workout_session_storage.dart';

final workoutSessionStorageProvider = Provider<WorkoutSessionStorage>(
  (ref) => const WorkoutSessionStorage(),
);
