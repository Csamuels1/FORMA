import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/workout_session_state.dart';

class WorkoutSessionStorage {
  static const _key = 'workout_session_state';

  const WorkoutSessionStorage();

  Future<WorkoutSessionState?> restore() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return null;

    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) {
      return WorkoutSessionState.fromJson(decoded);
    }
    if (decoded is Map) {
      return WorkoutSessionState.fromJson(decoded.cast<String, dynamic>());
    }
    return null;
  }

  Future<void> save(WorkoutSessionState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(state.toJson()));
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
