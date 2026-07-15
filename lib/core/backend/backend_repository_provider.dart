import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'backend_repository.dart';
import 'in_memory_backend_repository.dart';

final backendRepositoryProvider = Provider<BackendRepository>(
  (ref) => InMemoryBackendRepository(),
);
