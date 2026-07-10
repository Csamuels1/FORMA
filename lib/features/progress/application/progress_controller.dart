import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/app_seed_repository_provider.dart';
import '../domain/progress_state.dart';

final progressControllerProvider =
    StateNotifierProvider<ProgressController, ProgressState>(
  (ref) => ProgressController(ref.read(appSeedRepositoryProvider)),
);

class ProgressController extends StateNotifier<ProgressState> {
  ProgressController(this._seedRepository) : super(_seedRepository.progressState());

  final AppSeedRepository _seedRepository;

  void addWeightSample(double weightKg) {
    state = state.copyWith(
      currentWeightKg: weightKg,
      weightHistory: [...state.weightHistory, weightKg],
    );
  }

  void addPhotoCheckIn(String label) {
    state = state.copyWith(photoCheckIns: [...state.photoCheckIns, label]);
  }
}
