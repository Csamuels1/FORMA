class AccountState {
  const AccountState({
    required this.displayName,
    required this.email,
    required this.signedIn,
  });

  final String displayName;
  final String email;
  final bool signedIn;

  factory AccountState.initial() {
    return const AccountState(
      displayName: 'Guest',
      email: 'guest@forma.app',
      signedIn: false,
    );
  }

  AccountState copyWith({
    String? displayName,
    String? email,
    bool? signedIn,
  }) {
    return AccountState(
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      signedIn: signedIn ?? this.signedIn,
    );
  }
}
