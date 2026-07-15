import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/backend/backend_policy_controller.dart';
import '../domain/monetization_policy.dart';

final monetizationPolicyProvider = Provider<MonetizationPolicy>(
  (ref) => ref.watch(backendPolicyControllerProvider).toMonetizationPolicy(),
);
