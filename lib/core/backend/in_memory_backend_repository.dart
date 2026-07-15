import 'backend_policy_snapshot.dart';
import 'backend_repository.dart';
import 'backend_schema.dart';
import 'backend_sync_queue.dart';

class InMemoryBackendRepository implements BackendRepository {
  InMemoryBackendRepository();

  final Map<String, BackendUserRecord> _users = <String, BackendUserRecord>{};
  final BackendSyncQueue _syncQueue = BackendSyncQueue();
  BackendAuthSession _session = BackendAuthSession.guest();
  BackendPolicySnapshot _policy = BackendPolicySnapshot.defaults();

  @override
  Future<BackendAuthSession> bootstrapSession() async {
    return _session;
  }

  @override
  Future<BackendAuthSession> signIn({
    required String displayName,
    required String email,
    required String locale,
    required String region,
    required String tier,
  }) async {
    final userId = _stableUserId(email);
    final now = DateTime.now().toUtc().toIso8601String();
    final record = BackendUserRecord(
      id: userId,
      displayName: displayName,
      email: email,
      locale: locale,
      region: region,
      tier: tier,
      createdAtIso: _users[userId]?.createdAtIso ?? now,
      updatedAtIso: now,
    );
    _users[userId] = record;
    _syncQueue.enqueue(
      BackendQueuedWrite(
        kind: 'signIn',
        entityId: userId,
        payload: record.toJson(),
        createdAtIso: now,
      ),
    );
    _session = BackendAuthSession(
      signedIn: true,
      userId: userId,
      displayName: displayName,
      email: email,
      locale: locale,
      region: region,
      tier: tier,
      lastSyncedIso: now,
    );
    return _session;
  }

  @override
  Future<void> signOut() async {
    _syncQueue.enqueue(
      BackendQueuedWrite(
        kind: 'signOut',
        entityId: _session.userId ?? 'guest',
        payload: _session.toJson(),
        createdAtIso: DateTime.now().toUtc().toIso8601String(),
      ),
    );
    _session = BackendAuthSession.guest();
  }

  @override
  Future<void> deleteCurrentAccount() async {
    final userId = _session.userId;
    if (userId != null) {
      _users.remove(userId);
    }
    _syncQueue.enqueue(
      BackendQueuedWrite(
        kind: 'deleteCurrentAccount',
        entityId: userId ?? 'guest',
        payload: const <String, dynamic>{},
        createdAtIso: DateTime.now().toUtc().toIso8601String(),
      ),
    );
    _session = BackendAuthSession.guest();
  }

  @override
  Future<BackendUserRecord?> fetchUserRecord(String userId) async {
    return _users[userId];
  }

  @override
  Future<void> saveUserRecord(BackendUserRecord record) async {
    _users[record.id] = record;
    _syncQueue.enqueue(
      BackendQueuedWrite(
        kind: 'saveUserRecord',
        entityId: record.id,
        payload: record.toJson(),
        createdAtIso: record.updatedAtIso,
      ),
    );
  }

  @override
  Future<BackendPolicySnapshot> loadPolicySnapshot() async {
    return _policy;
  }

  Future<void> seedPolicySnapshot(BackendPolicySnapshot snapshot) async {
    _policy = snapshot;
  }

  int get pendingWriteCount => _syncQueue.pendingCount;

  String _stableUserId(String email) {
    return email.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
  }
}
