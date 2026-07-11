import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/photo_policy.dart';

final photoPolicyProvider = Provider<PhotoPolicy>(
  (ref) => const PhotoPolicy(
    storageMode: PhotoStorageMode.localOnly,
    retentionDays: 30,
    analysisMode: PhotoAnalysisMode.onDevice,
    requiresConsentBeforeCapture: true,
  ),
);
