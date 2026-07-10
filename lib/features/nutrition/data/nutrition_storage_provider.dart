import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'nutrition_storage.dart';

final nutritionStorageProvider = Provider<NutritionStorage>(
  (ref) => const NutritionStorage(),
);
