import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_seed_repository.dart';

export 'app_seed_repository.dart';

final appSeedRepositoryProvider = Provider<AppSeedRepository>(
  (ref) => const AppSeedRepository(),
);
