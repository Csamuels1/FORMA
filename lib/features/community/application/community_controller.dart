import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/app_seed_repository_provider.dart';
import '../domain/community_state.dart';

final communityControllerProvider =
    StateNotifierProvider<CommunityController, CommunityState>(
  (ref) => CommunityController(ref.read(appSeedRepositoryProvider)),
);

class CommunityController extends StateNotifier<CommunityState> {
  CommunityController(this._seedRepository) : super(_seedRepository.communityState());

  final AppSeedRepository _seedRepository;

  void likeFirstPost() {
    if (state.posts.isEmpty) return;
    final first = state.posts.first;
    final updated = CommunityPost(
      author: first.author,
      timeAgo: first.timeAgo,
      caption: first.caption,
      likes: first.likes + 1,
      comments: first.comments,
      milestone: first.milestone,
    );
    state = state.copyWith(posts: [updated, ...state.posts.skip(1)]);
  }

  void addFollow() {
    state = state.copyWith(followingCount: state.followingCount + 1);
  }
}
