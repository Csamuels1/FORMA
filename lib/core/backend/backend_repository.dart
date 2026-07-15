import 'backend_policy_snapshot.dart';
import 'backend_schema.dart';

abstract class BackendRepository {
  Future<BackendAuthSession> bootstrapSession();

  Future<BackendAuthSession> signIn({
    required String displayName,
    required String email,
    required String locale,
    required String region,
    required String tier,
  });

  Future<void> signOut();

  Future<void> deleteCurrentAccount();

  Future<BackendUserRecord?> fetchUserRecord(String userId);

  Future<void> saveUserRecord(BackendUserRecord record);

  Future<BackendPolicySnapshot> loadPolicySnapshot();
}
