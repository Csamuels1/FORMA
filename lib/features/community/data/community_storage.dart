import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/community_state.dart';

class CommunityStorage {
  static const _key = 'community_state';

  const CommunityStorage();

  Future<CommunityState?> restore() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return null;

    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) {
      return CommunityState.fromJson(decoded);
    }
    if (decoded is Map) {
      return CommunityState.fromJson(decoded.cast<String, dynamic>());
    }
    return null;
  }

  Future<void> save(CommunityState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(state.toJson()));
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
