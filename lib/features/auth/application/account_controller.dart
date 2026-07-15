import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/backend/backend_schema.dart';
import '../../../core/backend/backend_session_controller.dart';
import '../../../core/data/app_seed_repository_provider.dart';
import '../domain/account_state.dart';

final accountControllerProvider =
    StateNotifierProvider<AccountController, AccountState>(
  (ref) {
    final controller = AccountController(ref.read(appSeedRepositoryProvider));
    final backendSessionController =
        ref.read(backendSessionControllerProvider.notifier);
    controller.bindBackendSessionController(backendSessionController);
    ref.listen<BackendAuthSession>(
      backendSessionControllerProvider,
      (_, next) {
        controller.syncFromBackend(next);
      },
      fireImmediately: true,
    );
    return controller;
  },
);

class AccountController extends StateNotifier<AccountState> {
  AccountController(this._seedRepository)
      : super(_seedRepository.accountState());

  final AppSeedRepository _seedRepository;
  BackendSessionController? _backendSessionController;

  void bindBackendSessionController(
    BackendSessionController backendSessionController,
  ) {
    _backendSessionController = backendSessionController;
  }

  void syncFromBackend(BackendAuthSession session) {
    state = session.toAccountState();
  }

  void signIn() {
    final backendSessionController = _backendSessionController;
    if (backendSessionController != null) {
      unawaited(
        backendSessionController.signIn(
          displayName: 'FORMA Athlete',
          email: 'athlete@forma.app',
          locale: 'en_NG',
          region: 'Nigeria',
          tier: 'free',
        ),
      );
    }
    state = state.copyWith(
      displayName: 'FORMA Athlete',
      email: 'athlete@forma.app',
      signedIn: true,
    );
  }

  void signOut() {
    unawaited(_backendSessionController?.signOut());
    state = _seedRepository.accountState();
  }

  void deleteAccount() {
    unawaited(_backendSessionController?.deleteCurrentAccount());
    state = _seedRepository.accountState();
  }
}
