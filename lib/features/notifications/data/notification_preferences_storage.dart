import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/notification_preferences.dart';

class NotificationPreferencesStorage {
  static const _key = 'notification_preferences';

  const NotificationPreferencesStorage();

  Future<NotificationPreferences?> restore() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return null;

    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) {
      return NotificationPreferences.fromJson(decoded);
    }
    if (decoded is Map) {
      return NotificationPreferences.fromJson(decoded.cast<String, dynamic>());
    }
    return null;
  }

  Future<void> save(NotificationPreferences state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(state.toJson()));
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
