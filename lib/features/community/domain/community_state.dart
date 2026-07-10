class CommunityState {
  const CommunityState({
    required this.posts,
    required this.followingCount,
    required this.commentCount,
  });

  final List<CommunityPost> posts;
  final int followingCount;
  final int commentCount;

  factory CommunityState.initial() {
    return const CommunityState(
      posts: [
        CommunityPost(
          author: 'Marcus',
          timeAgo: '12m',
          caption: 'Day 12. Short session, no excuses.',
          likes: 24,
          comments: 4,
          milestone: true,
        ),
        CommunityPost(
          author: 'Owen',
          timeAgo: '42m',
          caption: 'Meal prep sorted for the week.',
          likes: 18,
          comments: 2,
          milestone: false,
        ),
      ],
      followingCount: 18,
      commentCount: 6,
    );
  }

  CommunityState copyWith({
    List<CommunityPost>? posts,
    int? followingCount,
    int? commentCount,
  }) {
    return CommunityState(
      posts: posts ?? this.posts,
      followingCount: followingCount ?? this.followingCount,
      commentCount: commentCount ?? this.commentCount,
    );
  }
}

class CommunityPost {
  const CommunityPost({
    required this.author,
    required this.timeAgo,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.milestone,
  });

  final String author;
  final String timeAgo;
  final String caption;
  final int likes;
  final int comments;
  final bool milestone;
}
