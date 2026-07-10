import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/app_seed_repository_provider.dart';
import '../domain/account_state.dart';

final accountControllerProvider =
    StateNotifierProvider<AccountController, AccountState>(
  (ref) => AccountController(ref.read(appSeedRepositoryProvider)),
);

class AccountController extends StateNotifier<AccountState> {
  AccountController(this._seedRepository) : super(_seedRepository.accountState());

  final AppSeedRepository _seedRepository;

  void signIn() {
    state = state.copyWith(
      displayName: 'FORMA Athlete',
      email: 'athlete@forma.app',
      signedIn: true,
    );
  }

  void signOut() {
    state = _seedRepository.accountState();
  }
}
