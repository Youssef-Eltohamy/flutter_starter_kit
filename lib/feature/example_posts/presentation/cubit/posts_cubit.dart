import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter_kit/feature/example_posts/data/posts_repository.dart';
import 'package:flutter_starter_kit/feature/example_posts/presentation/cubit/posts_state.dart';

/// Drives the posts screen. Calls the repository and folds the
/// `Either<Failure, T>` result into a single [PostsState].
class PostsCubit extends Cubit<PostsState> {
  PostsCubit(this._repository) : super(const PostsState());

  final PostsRepository _repository;

  Future<void> loadPosts() async {
    emit(state.copyWith(status: PostsStatus.loading));
    final result = await _repository.getPosts();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PostsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (posts) => emit(state.copyWith(status: PostsStatus.success, posts: posts)),
    );
  }
}
