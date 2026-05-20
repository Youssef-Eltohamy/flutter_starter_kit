import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter_kit/feature/example_posts/data/posts_repository.dart';
import 'package:flutter_starter_kit/feature/example_posts/presentation/cubit/posts_cubit.dart';
import 'package:flutter_starter_kit/feature/example_posts/presentation/cubit/posts_state.dart';
import 'package:flutter_starter_kit/injection.dart';

/// Reference example screen. Shows the recommended wiring:
/// BlocProvider creates the Cubit from a get_it dependency, and BlocBuilder
/// renders one widget per [PostsStatus].
class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostsCubit(getIt<PostsRepository>())..loadPosts(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Posts (example)')),
        body: BlocBuilder<PostsCubit, PostsState>(
          builder: (context, state) {
            switch (state.status) {
              case PostsStatus.initial:
              case PostsStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case PostsStatus.failure:
                return _ErrorView(
                  message: state.errorMessage ?? 'Unknown error',
                  onRetry: () => context.read<PostsCubit>().loadPosts(),
                );
              case PostsStatus.success:
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.posts.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final post = state.posts[index];
                    return ListTile(
                      title: Text(post.title),
                      subtitle: Text(post.body),
                    );
                  },
                );
            }
          },
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
