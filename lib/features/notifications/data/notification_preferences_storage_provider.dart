import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notification_preferences_storage.dart';

final notificationPreferencesStorageProvider =
    Provider<NotificationPreferencesStorage>(
  (ref) => const NotificationPreferencesStorage(),
);
