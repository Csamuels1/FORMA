import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/monetization_policy.dart';

final monetizationPolicyProvider = Provider<MonetizationPolicy>(
  (ref) => const MonetizationPolicy.defaults(),
);
