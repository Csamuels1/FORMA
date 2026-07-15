import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../backend/backend_policy_controller.dart';
import '../models/photo_policy.dart';

final photoPolicyProvider = Provider<PhotoPolicy>(
  (ref) => ref.watch(backendPolicyControllerProvider).toPhotoPolicy(),
);
