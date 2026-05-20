import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/core/widgets/base_stateful_screen_widget.dart';
import 'package:flutter_starter_kit/feature/example_posts/data/models/post.dart';
import 'package:flutter_starter_kit/feature/example_posts/presentation/screen/post_details_view.dart';

/// Details screen for a single [Post]. Built on [BaseStatefulScreenWidget] to
/// demonstrate the shared screen base (loading overlay + connectivity banner).
class PostDetailsScreen extends BaseStatefulScreenWidget {
  const PostDetailsScreen({super.key, required this.post});

  final Post? post;

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends BaseScreenState<PostDetailsScreen> {
  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post')),
      body: PostDetailsView(post: widget.post),
    );
  }
}
