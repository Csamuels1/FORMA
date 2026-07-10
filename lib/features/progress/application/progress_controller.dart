import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/app_seed_repository_provider.dart';
import '../domain/progress_entry.dart';
import '../domain/progress_state.dart';

final progressControllerProvider =
    StateNotifierProvider<ProgressController, ProgressState>(
  (ref) => ProgressController(ref.read(appSeedRepositoryProvider)),
);

class ProgressController extends StateNotifier<ProgressState> {
  ProgressController(this._seedRepository)
      : super(_seedRepository.progressState());

  final AppSeedRepository _seedRepository;

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
  }
}
