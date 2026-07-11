import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/streak_state.dart';

class StreakStorage {
  static const _key = 'streak_state';

  const StreakStorage();

  Future<StreakState?> restore() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return null;

    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) {
      return StreakState.fromJson(decoded);
    }
    if (decoded is Map) {
      return StreakState.fromJson(decoded.cast<String, dynamic>());
    }
    return null;
  }

  Future<void> save(StreakState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(state.toJson()));
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
