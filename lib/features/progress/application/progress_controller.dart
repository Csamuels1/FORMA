import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/app_seed_repository_provider.dart';
import '../data/progress_storage.dart';
import '../data/progress_storage_provider.dart';
import '../domain/progress_entry.dart';
import '../domain/progress_state.dart';

final progressControllerProvider =
    StateNotifierProvider<ProgressController, ProgressState>(
  (ref) {
    final storage = ref.read(progressStorageProvider);
    final controller = ProgressController(
      ref.read(appSeedRepositoryProvider),
      storage,
    );
    unawaited(storage.restore().then(controller.hydrateFromStorage));
    return controller;
  },
);

class ProgressController extends StateNotifier<ProgressState> {
  ProgressController(this._seedRepository, this._storage)
      : super(_seedRepository.progressState());

  final AppSeedRepository _seedRepository;
  final ProgressStorage _storage;

  void hydrateFromStorage(ProgressState? restored) {
    if (restored == null) return;
    state = restored;
  }

  void addWeightSample(double weightKg) {
    state = state.copyWith(
      currentWeightKg: weightKg,
      entries: [
        ...state.entries,
        ProgressEntry(
          kind: ProgressEntryKind.weight,
          label: '${weightKg.toStringAsFixed(1)} kg',
          detail: 'Weight sample added today',
        ),
      ],
    );
    unawaited(_storage.save(state));
  }

  void addPhotoCheckIn(String label) {
    state = state.copyWith(
      entries: [
        ...state.entries,
        ProgressEntry(
          kind: ProgressEntryKind.photo,
          label: label,
          detail: 'Photo check-in recorded',
        ),
      ],
    );
    unawaited(_storage.save(state));
  }

  void clearPhotoCheckIns() {
    state = state.copyWith(
      entries: state.entries
          .where((entry) => entry.kind != ProgressEntryKind.photo)
          .toList(),
    );
    unawaited(_storage.save(state));
  }

  void clearProgressData() {
    state = const ProgressState(currentWeightKg: 0, entries: []);
    unawaited(_storage.clear());
  }

  void resetProgress() {
    state = _seedRepository.progressState();
    unawaited(_storage.clear());
  }
}
