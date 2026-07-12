import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/forma_empty_state.dart';
import '../../../core/widgets/forma_error_state.dart';
import '../../../core/widgets/forma_loading_state.dart';
import '../../../core/widgets/forma_page_shell.dart';
import '../../../core/widgets/forma_section_card.dart';
import '../application/community_controller.dart';
import '../domain/community_state.dart';

class CommunityFeedScreen extends ConsumerWidget {
  const CommunityFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(communityControllerProvider);
    final controller = ref.read(communityControllerProvider.notifier);

    return FormaPageShell(
      appBar: AppBar(title: const Text('Community')),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 920;
          final feed = state.posts.isEmpty
              ? const FormaEmptyState(
                  title: 'No posts yet',
                  message:
                      'Your feed is quiet for now. The first posts will appear here.',
                )
              : _CommunityFeed(
                  posts: state.posts,
                  onLike: controller.likePost,
                  onComment: controller.commentOnPost,
                  onFollow: controller.addFollow,
                  onShareUpdate: controller.addUpdate,
                );

          final sidePanel = FormaSectionCard(
            padding: const EdgeInsets.all(28),
            child: _CommunityStats(state: state),
          );

          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 7, child: feed),
                const SizedBox(width: 18),
                Expanded(flex: 4, child: sidePanel),
              ],
            );
          }

          return Column(
            children: [
              feed,
              const SizedBox(height: 18),
              sidePanel,
            ],
          );
        },
      ),
    );
  }
}

class _CommunityFeed extends StatelessWidget {
  const _CommunityFeed({
    required this.posts,
    required this.onLike,
    required this.onComment,
    required this.onFollow,
    required this.onShareUpdate,
  });

  final List<CommunityPost> posts;
  final void Function(int index) onLike;
  final void Function(int index) onComment;
  final VoidCallback onFollow;
  final VoidCallback onShareUpdate;

  @override
  Widget build(BuildContext context) {
    return FormaSectionCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Feed', style: Theme.of(context).textTheme.headlineMedium),
              Wrap(
                spacing: 8,
                children: [
                  TextButton(
                    onPressed: onFollow,
                    child: const Text('Follow more'),
                  ),
                  FilledButton.tonal(
                    onPressed: onShareUpdate,
                    child: const Text('Share update'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...posts.asMap().entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _PostCard(
                    post: entry.value,
                    onLike: () => onLike(entry.key),
                    onComment: () => onComment(entry.key),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({
    required this.post,
    required this.onLike,
    required this.onComment,
  });

  final CommunityPost post;
  final VoidCallback onLike;
  final VoidCallback onComment;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  child: Text(post.author.isNotEmpty ? post.author[0] : '?'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.author,
                          style: Theme.of(context).textTheme.titleMedium),
                      Text(post.timeAgo),
                    ],
                  ),
                ),
                if (post.milestone)
                  Chip(
                    label: const Text('Milestone'),
                    backgroundColor:
                        Theme.of(context).colorScheme.tertiaryContainer,
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Text(post.caption, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 14),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                OutlinedButton.icon(
                  onPressed: onLike,
                  icon: const Icon(Icons.favorite_border),
                  label: Text('${post.likes}'),
                ),
                OutlinedButton.icon(
                  onPressed: onComment,
                  icon: const Icon(Icons.mode_comment_outlined),
                  label: Text('${post.comments}'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CommunityStats extends StatelessWidget {
  const _CommunityStats({required this.state});

  final CommunityState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Community stats',
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        const FormaLoadingState(label: 'Feed updates stay lightweight'),
        const SizedBox(height: 16),
        _StatRow(label: 'Following', value: state.followingCount.toString()),
        _StatRow(label: 'Comments', value: state.commentCount.toString()),
        const SizedBox(height: 20),
        const FormaErrorState(
          title: 'Guardrails',
          message:
              'Moderation and ad placement rules will be enforced centrally.',
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
