import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'community_storage.dart';

final communityStorageProvider = Provider<CommunityStorage>(
  (ref) => const CommunityStorage(),
);
