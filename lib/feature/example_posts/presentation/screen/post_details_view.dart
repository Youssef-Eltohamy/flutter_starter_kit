import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/core/extensions/context_extensions.dart';
import 'package:flutter_starter_kit/feature/example_posts/data/models/post.dart';

/// Pure, framework-light content for the post details screen — kept separate
/// from the screen scaffold so it is trivial to test.
class PostDetailsView extends StatelessWidget {
  const PostDetailsView({super.key, required this.post});

  final Post? post;

  @override
  Widget build(BuildContext context) {
    final post = this.post;
    if (post == null) {
      return const Center(child: Text('Post not found'));
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(post.title, style: context.textTheme.titleLarge),
          const SizedBox(height: 12),
          Text(post.body),
        ],
      ),
    );
  }
}
