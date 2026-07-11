import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'streak_storage.dart';

final streakStorageProvider = Provider<StreakStorage>(
  (ref) => const StreakStorage(),
);
