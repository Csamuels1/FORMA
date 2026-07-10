import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/nutrition_state.dart';

class NutritionStorage {
  static const _key = 'nutrition_state';

  const NutritionStorage();

  Future<NutritionState?> restore() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return null;

    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) {
      return NutritionState.fromJson(decoded);
    }
    if (decoded is Map) {
      return NutritionState.fromJson(decoded.cast<String, dynamic>());
    }
    return null;
  }

  Future<void> save(NutritionState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(state.toJson()));
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
