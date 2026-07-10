import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/progress_state.dart';

class ProgressStorage {
  static const _key = 'progress_state';

  const ProgressStorage();

  Future<ProgressState?> restore() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return null;

    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) {
      return ProgressState.fromJson(decoded);
    }
    if (decoded is Map) {
      return ProgressState.fromJson(decoded.cast<String, dynamic>());
    }
    return null;
  }

  Future<void> save(ProgressState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(state.toJson()));
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
