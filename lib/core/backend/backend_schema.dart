import '../../features/auth/domain/account_state.dart';
import '../models/app_user.dart';

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return value.cast<String, dynamic>();
  return const <String, dynamic>{};
}

List<Map<String, dynamic>> _asMapList(dynamic value) {
  if (value is! List) return const <Map<String, dynamic>>[];
  return value
      .whereType<Map>()
      .map((item) => item.cast<String, dynamic>())
      .toList();
}

List<String> _asStringList(dynamic value) {
  if (value is! List) return const <String>[];
  return value.whereType<String>().toList();
}

class BackendAuthSession {
  const BackendAuthSession({
    required this.signedIn,
    required this.userId,
    required this.displayName,
    required this.email,
    required this.locale,
    required this.region,
    required this.tier,
    required this.lastSyncedIso,
  });

  final bool signedIn;
  final String? userId;
  final String displayName;
  final String email;
  final String locale;
  final String region;
  final String tier;
  final String? lastSyncedIso;

  factory BackendAuthSession.guest() {
    return const BackendAuthSession(
      signedIn: false,
      userId: null,
      displayName: 'Guest',
      email: 'guest@forma.app',
      locale: 'en_NG',
      region: 'Nigeria',
      tier: 'free',
      lastSyncedIso: null,
    );
  }

  static BackendAuthSession fromAccountState(AccountState state) {
    return BackendAuthSession(
      signedIn: state.signedIn,
      userId: state.signedIn ? 'forma-${state.email}' : null,
      displayName: state.displayName,
      email: state.email,
      locale: 'en_NG',
      region: 'Nigeria',
      tier: 'free',
      lastSyncedIso: null,
    );
  }

  AccountState toAccountState() {
    return AccountState(
      displayName: displayName,
      email: email,
      signedIn: signedIn,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'signedIn': signedIn,
      'userId': userId,
      'displayName': displayName,
      'email': email,
      'locale': locale,
      'region': region,
      'tier': tier,
      'lastSyncedIso': lastSyncedIso,
    };
  }

  factory BackendAuthSession.fromJson(Map<String, dynamic> json) {
    final seed = BackendAuthSession.guest();
    return BackendAuthSession(
      signedIn: json['signedIn'] as bool? ?? seed.signedIn,
      userId: json['userId'] as String?,
      displayName: json['displayName'] as String? ?? seed.displayName,
      email: json['email'] as String? ?? seed.email,
      locale: json['locale'] as String? ?? seed.locale,
      region: json['region'] as String? ?? seed.region,
      tier: json['tier'] as String? ?? seed.tier,
      lastSyncedIso: json['lastSyncedIso'] as String?,
    );
  }
}

class BackendUserRecord {
  const BackendUserRecord({
    required this.id,
    required this.displayName,
    required this.email,
    required this.locale,
    required this.region,
    required this.tier,
    required this.createdAtIso,
    required this.updatedAtIso,
  });

  final String id;
  final String displayName;
  final String email;
  final String locale;
  final String region;
  final String tier;
  final String createdAtIso;
  final String updatedAtIso;

  factory BackendUserRecord.fromAppUser(
    AppUser user, {
    required String email,
    required String createdAtIso,
    required String updatedAtIso,
  }) {
    return BackendUserRecord(
      id: user.id,
      displayName: user.displayName,
      email: email,
      locale: user.locale,
      region: user.region,
      tier: user.tier.name,
      createdAtIso: createdAtIso,
      updatedAtIso: updatedAtIso,
    );
  }

  AppUser toAppUser() {
    return AppUser(
      id: id,
      displayName: displayName,
      locale: locale,
      region: region,
      tier: tier == 'pro' ? SubscriptionTier.pro : SubscriptionTier.free,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'email': email,
      'locale': locale,
      'region': region,
      'tier': tier,
      'createdAtIso': createdAtIso,
      'updatedAtIso': updatedAtIso,
    };
  }

  factory BackendUserRecord.fromJson(Map<String, dynamic> json) {
    return BackendUserRecord(
      id: json['id'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      locale: json['locale'] as String? ?? 'en_NG',
      region: json['region'] as String? ?? 'Nigeria',
      tier: json['tier'] as String? ?? 'free',
      createdAtIso: json['createdAtIso'] as String? ?? '',
      updatedAtIso: json['updatedAtIso'] as String? ?? '',
    );
  }
}

class BackendExerciseRecord {
  const BackendExerciseRecord({
    required this.id,
    required this.planId,
    required this.name,
    required this.sets,
    required this.reps,
    required this.restSeconds,
    required this.demoUrl,
  });

  final String id;
  final String planId;
  final String name;
  final int sets;
  final int reps;
  final int restSeconds;
  final String? demoUrl;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'planId': planId,
      'name': name,
      'sets': sets,
      'reps': reps,
      'restSeconds': restSeconds,
      'demoUrl': demoUrl,
    };
  }

  factory BackendExerciseRecord.fromJson(Map<String, dynamic> json) {
    return BackendExerciseRecord(
      id: json['id'] as String? ?? '',
      planId: json['planId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      sets: json['sets'] as int? ?? 0,
      reps: json['reps'] as int? ?? 0,
      restSeconds: json['restSeconds'] as int? ?? 0,
      demoUrl: json['demoUrl'] as String?,
    );
  }
}

class BackendWorkoutPlanRecord {
  const BackendWorkoutPlanRecord({
    required this.id,
    required this.userId,
    required this.goal,
    required this.environment,
    required this.daysPerWeek,
    required this.progressionRules,
    required this.exercises,
  });

  final String id;
  final String userId;
  final String goal;
  final String environment;
  final int daysPerWeek;
  final Map<String, dynamic> progressionRules;
  final List<BackendExerciseRecord> exercises;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'goal': goal,
      'environment': environment,
      'daysPerWeek': daysPerWeek,
      'progressionRules': progressionRules,
      'exercises': exercises.map((exercise) => exercise.toJson()).toList(),
    };
  }

  factory BackendWorkoutPlanRecord.fromJson(Map<String, dynamic> json) {
    return BackendWorkoutPlanRecord(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      goal: json['goal'] as String? ?? '',
      environment: json['environment'] as String? ?? '',
      daysPerWeek: json['daysPerWeek'] as int? ?? 0,
      progressionRules: _asMap(json['progressionRules']),
      exercises: _asMapList(json['exercises'])
          .map(BackendExerciseRecord.fromJson)
          .toList(),
    );
  }
}

class BackendSessionRecord {
  const BackendSessionRecord({
    required this.id,
    required this.userId,
    required this.planId,
    required this.dateIso,
    required this.status,
    required this.completedSets,
    required this.summary,
  });

  final String id;
  final String userId;
  final String planId;
  final String dateIso;
  final String status;
  final int completedSets;
  final String summary;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'planId': planId,
      'dateIso': dateIso,
      'status': status,
      'completedSets': completedSets,
      'summary': summary,
    };
  }

  factory BackendSessionRecord.fromJson(Map<String, dynamic> json) {
    return BackendSessionRecord(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      planId: json['planId'] as String? ?? '',
      dateIso: json['dateIso'] as String? ?? '',
      status: json['status'] as String? ?? '',
      completedSets: json['completedSets'] as int? ?? 0,
      summary: json['summary'] as String? ?? '',
    );
  }
}

class BackendFoodLogRecord {
  const BackendFoodLogRecord({
    required this.id,
    required this.userId,
    required this.dateIso,
    required this.calories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.mealItems,
  });

  final String id;
  final String userId;
  final String dateIso;
  final int calories;
  final int proteinGrams;
  final int carbsGrams;
  final int fatGrams;
  final List<String> mealItems;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'dateIso': dateIso,
      'calories': calories,
      'proteinGrams': proteinGrams,
      'carbsGrams': carbsGrams,
      'fatGrams': fatGrams,
      'mealItems': mealItems,
    };
  }

  factory BackendFoodLogRecord.fromJson(Map<String, dynamic> json) {
    return BackendFoodLogRecord(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      dateIso: json['dateIso'] as String? ?? '',
      calories: json['calories'] as int? ?? 0,
      proteinGrams: json['proteinGrams'] as int? ?? 0,
      carbsGrams: json['carbsGrams'] as int? ?? 0,
      fatGrams: json['fatGrams'] as int? ?? 0,
      mealItems: _asStringList(json['mealItems']),
    );
  }
}

class BackendPhotoRecord {
  const BackendPhotoRecord({
    required this.id,
    required this.userId,
    required this.type,
    required this.storageRef,
    required this.createdAtIso,
    required this.retentionPolicy,
    required this.analysisStatus,
  });

  final String id;
  final String userId;
  final String type;
  final String storageRef;
  final String createdAtIso;
  final String retentionPolicy;
  final String analysisStatus;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'storageRef': storageRef,
      'createdAtIso': createdAtIso,
      'retentionPolicy': retentionPolicy,
      'analysisStatus': analysisStatus,
    };
  }

  factory BackendPhotoRecord.fromJson(Map<String, dynamic> json) {
    return BackendPhotoRecord(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      type: json['type'] as String? ?? '',
      storageRef: json['storageRef'] as String? ?? '',
      createdAtIso: json['createdAtIso'] as String? ?? '',
      retentionPolicy: json['retentionPolicy'] as String? ?? '',
      analysisStatus: json['analysisStatus'] as String? ?? '',
    );
  }
}

class BackendStreakRecord {
  const BackendStreakRecord({
    required this.userId,
    required this.currentCount,
    required this.bestCount,
    required this.freezeBalance,
    required this.lastActiveDateIso,
  });

  final String userId;
  final int currentCount;
  final int bestCount;
  final int freezeBalance;
  final String? lastActiveDateIso;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'currentCount': currentCount,
      'bestCount': bestCount,
      'freezeBalance': freezeBalance,
      'lastActiveDateIso': lastActiveDateIso,
    };
  }

  factory BackendStreakRecord.fromJson(Map<String, dynamic> json) {
    return BackendStreakRecord(
      userId: json['userId'] as String? ?? '',
      currentCount: json['currentCount'] as int? ?? 0,
      bestCount: json['bestCount'] as int? ?? 0,
      freezeBalance: json['freezeBalance'] as int? ?? 0,
      lastActiveDateIso: json['lastActiveDateIso'] as String?,
    );
  }
}

class BackendCommunityPostRecord {
  const BackendCommunityPostRecord({
    required this.id,
    required this.userId,
    required this.author,
    required this.caption,
    required this.createdAtIso,
    required this.likeCount,
    required this.commentCount,
    required this.milestone,
  });

  final String id;
  final String userId;
  final String author;
  final String caption;
  final String createdAtIso;
  final int likeCount;
  final int commentCount;
  final bool milestone;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'author': author,
      'caption': caption,
      'createdAtIso': createdAtIso,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'milestone': milestone,
    };
  }

  factory BackendCommunityPostRecord.fromJson(Map<String, dynamic> json) {
    return BackendCommunityPostRecord(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      author: json['author'] as String? ?? '',
      caption: json['caption'] as String? ?? '',
      createdAtIso: json['createdAtIso'] as String? ?? '',
      likeCount: json['likeCount'] as int? ?? 0,
      commentCount: json['commentCount'] as int? ?? 0,
      milestone: json['milestone'] as bool? ?? false,
    );
  }
}

class BackendCommunityCommentRecord {
  const BackendCommunityCommentRecord({
    required this.id,
    required this.postId,
    required this.userId,
    required this.body,
    required this.createdAtIso,
  });

  final String id;
  final String postId;
  final String userId;
  final String body;
  final String createdAtIso;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'body': body,
      'createdAtIso': createdAtIso,
    };
  }

  factory BackendCommunityCommentRecord.fromJson(Map<String, dynamic> json) {
    return BackendCommunityCommentRecord(
      id: json['id'] as String? ?? '',
      postId: json['postId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      body: json['body'] as String? ?? '',
      createdAtIso: json['createdAtIso'] as String? ?? '',
    );
  }
}

class BackendCommunityReactionRecord {
  const BackendCommunityReactionRecord({
    required this.id,
    required this.postId,
    required this.userId,
    required this.kind,
    required this.createdAtIso,
  });

  final String id;
  final String postId;
  final String userId;
  final String kind;
  final String createdAtIso;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'kind': kind,
      'createdAtIso': createdAtIso,
    };
  }

  factory BackendCommunityReactionRecord.fromJson(Map<String, dynamic> json) {
    return BackendCommunityReactionRecord(
      id: json['id'] as String? ?? '',
      postId: json['postId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      kind: json['kind'] as String? ?? '',
      createdAtIso: json['createdAtIso'] as String? ?? '',
    );
  }
}

class BackendCommunityFollowRecord {
  const BackendCommunityFollowRecord({
    required this.id,
    required this.userId,
    required this.followedUserId,
    required this.createdAtIso,
  });

  final String id;
  final String userId;
  final String followedUserId;
  final String createdAtIso;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'followedUserId': followedUserId,
      'createdAtIso': createdAtIso,
    };
  }

  factory BackendCommunityFollowRecord.fromJson(Map<String, dynamic> json) {
    return BackendCommunityFollowRecord(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      followedUserId: json['followedUserId'] as String? ?? '',
      createdAtIso: json['createdAtIso'] as String? ?? '',
    );
  }
}
