import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'progress_storage.dart';

final progressStorageProvider = Provider<ProgressStorage>(
  (ref) => const ProgressStorage(),
);
