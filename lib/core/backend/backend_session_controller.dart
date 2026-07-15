import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/domain/account_state.dart';
import 'backend_repository.dart';
import 'backend_repository_provider.dart';
import 'backend_schema.dart';

final backendSessionControllerProvider =
    StateNotifierProvider<BackendSessionController, BackendAuthSession>(
  (ref) {
    final controller =
        BackendSessionController(ref.read(backendRepositoryProvider));
    unawaited(controller.bootstrap());
    return controller;
  },
);

class BackendSessionController extends StateNotifier<BackendAuthSession> {
  BackendSessionController(this._repository)
      : super(BackendAuthSession.guest());

  final BackendRepository _repository;

  Future<void> bootstrap() async {
    state = await _repository.bootstrapSession();
  }

  Future<void> signIn({
    required String displayName,
    required String email,
    required String locale,
    required String region,
    required String tier,
  }) async {
    state = BackendAuthSession(
      signedIn: true,
      userId: state.userId ?? _sessionUserId(email),
      displayName: displayName,
      email: email,
      locale: locale,
      region: region,
      tier: tier,
      lastSyncedIso: DateTime.now().toUtc().toIso8601String(),
    );
    state = await _repository.signIn(
      displayName: displayName,
      email: email,
      locale: locale,
      region: region,
      tier: tier,
    );
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = BackendAuthSession.guest();
  }

  Future<void> deleteCurrentAccount() async {
    await _repository.deleteCurrentAccount();
    state = BackendAuthSession.guest();
  }

  void hydrateFromAccountState(AccountState accountState) {
    state = BackendAuthSession.fromAccountState(accountState);
  }

  String _sessionUserId(String email) {
    return 'forma-${email.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-')}';
  }
}
