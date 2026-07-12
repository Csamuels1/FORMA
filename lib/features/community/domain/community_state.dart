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

  Map<String, dynamic> toJson() {
    return {
      'posts': posts.map((post) => post.toJson()).toList(),
      'followingCount': followingCount,
      'commentCount': commentCount,
    };
  }

  factory CommunityState.fromJson(Map<String, dynamic> json) {
    final seed = CommunityState.initial();
    final postsJson = json['posts'];
    return CommunityState(
      posts: postsJson is List
          ? postsJson
              .whereType<Map>()
              .map((item) =>
                  CommunityPost.fromJson(item.cast<String, dynamic>()))
              .toList()
          : seed.posts,
      followingCount: json['followingCount'] as int? ?? seed.followingCount,
      commentCount: json['commentCount'] as int? ?? seed.commentCount,
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

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'timeAgo': timeAgo,
      'caption': caption,
      'likes': likes,
      'comments': comments,
      'milestone': milestone,
    };
  }

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    return CommunityPost(
      author: json['author'] as String? ?? '',
      timeAgo: json['timeAgo'] as String? ?? '',
      caption: json['caption'] as String? ?? '',
      likes: json['likes'] as int? ?? 0,
      comments: json['comments'] as int? ?? 0,
      milestone: json['milestone'] as bool? ?? false,
    );
  }
}
