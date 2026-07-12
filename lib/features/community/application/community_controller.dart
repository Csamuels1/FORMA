import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/app_seed_repository_provider.dart';
import '../data/community_storage.dart';
import '../data/community_storage_provider.dart';
import '../domain/community_state.dart';

final communityControllerProvider =
    StateNotifierProvider<CommunityController, CommunityState>(
  (ref) {
    final storage = ref.read(communityStorageProvider);
    final controller = CommunityController(
      ref.read(appSeedRepositoryProvider),
      storage,
    );
    unawaited(storage.restore().then(controller.hydrateFromStorage));
    return controller;
  },
);

class CommunityController extends StateNotifier<CommunityState> {
  CommunityController(this._seedRepository, this._storage)
      : super(_seedRepository.communityState());

  final AppSeedRepository _seedRepository;
  final CommunityStorage _storage;

  void hydrateFromStorage(CommunityState? restored) {
    if (restored == null) return;
    state = restored;
  }

  void likePost(int index) {
    if (index < 0 || index >= state.posts.length) return;
    final updatedPosts = [...state.posts];
    final first = updatedPosts[index];
    updatedPosts[index] = CommunityPost(
      author: first.author,
      timeAgo: first.timeAgo,
      caption: first.caption,
      likes: first.likes + 1,
      comments: first.comments,
      milestone: first.milestone,
    );
    state = state.copyWith(posts: updatedPosts);
    unawaited(_storage.save(state));
  }

  void commentOnPost(int index) {
    if (index < 0 || index >= state.posts.length) return;
    final updatedPosts = [...state.posts];
    final first = updatedPosts[index];
    updatedPosts[index] = CommunityPost(
      author: first.author,
      timeAgo: first.timeAgo,
      caption: first.caption,
      likes: first.likes,
      comments: first.comments + 1,
      milestone: first.milestone,
    );
    state = state.copyWith(
      posts: updatedPosts,
      commentCount: state.commentCount + 1,
    );
    unawaited(_storage.save(state));
  }

  void addFollow() {
    state = state.copyWith(followingCount: state.followingCount + 1);
    unawaited(_storage.save(state));
  }

  void addUpdate() {
    final updatedPost = CommunityPost(
      author: 'You',
      timeAgo: 'Just now',
      caption: 'Completed a session and kept the day clean.',
      likes: 0,
      comments: 0,
      milestone: true,
    );
    state = state.copyWith(posts: [updatedPost, ...state.posts]);
    unawaited(_storage.save(state));
  }

  void resetCommunity() {
    state = _seedRepository.communityState();
    unawaited(_storage.clear());
  }

  void clearCommunityData() {
    state = const CommunityState(
      posts: [],
      followingCount: 0,
      commentCount: 0,
    );
    unawaited(_storage.clear());
  }
}
