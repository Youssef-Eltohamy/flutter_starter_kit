import 'package:equatable/equatable.dart';
import 'package:flutter_starter_kit/feature/example_posts/data/models/post.dart';

enum PostsStatus { initial, loading, success, failure }

/// Single immutable state object for the posts screen. Prefer one state class
/// with a status enum over many subclasses — it is simpler to read and copy.
class PostsState extends Equatable {
  const PostsState({
    this.status = PostsStatus.initial,
    this.posts = const [],
    this.errorMessage,
  });

  final PostsStatus status;
  final List<Post> posts;
  final String? errorMessage;

  PostsState copyWith({
    PostsStatus? status,
    List<Post>? posts,
    String? errorMessage,
  }) {
    return PostsState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, posts, errorMessage];
}
