import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'backend_policy_snapshot.dart';
import 'backend_repository.dart';
import 'backend_repository_provider.dart';

final backendPolicyControllerProvider =
    StateNotifierProvider<BackendPolicyController, BackendPolicySnapshot>(
  (ref) {
    final controller =
        BackendPolicyController(ref.read(backendRepositoryProvider));
    unawaited(controller.bootstrap());
    return controller;
  },
);

class BackendPolicyController extends StateNotifier<BackendPolicySnapshot> {
  BackendPolicyController(this._repository)
      : super(BackendPolicySnapshot.defaults());

  final BackendRepository _repository;

  Future<void> bootstrap() async {
    final snapshot = await _repository.loadPolicySnapshot();
    state = snapshot;
  }
}
