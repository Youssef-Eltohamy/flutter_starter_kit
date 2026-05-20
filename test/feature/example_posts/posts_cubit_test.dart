import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_starter_kit/core/failures.dart';
import 'package:flutter_starter_kit/feature/example_posts/data/models/post.dart';
import 'package:flutter_starter_kit/feature/example_posts/data/posts_repository.dart';
import 'package:flutter_starter_kit/feature/example_posts/presentation/cubit/posts_cubit.dart';
import 'package:flutter_starter_kit/feature/example_posts/presentation/cubit/posts_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostsRepository extends Mock implements PostsRepository {}

void main() {
  late MockPostsRepository repository;

  const posts = [Post(id: 1, title: 'a', body: 'b')];

  setUp(() => repository = MockPostsRepository());

  blocTest<PostsCubit, PostsState>(
    'emits [loading, success] when posts load successfully',
    setUp: () => when(
      () => repository.getPosts(),
    ).thenAnswer((_) async => const Right(posts)),
    build: () => PostsCubit(repository),
    act: (cubit) => cubit.loadPosts(),
    expect: () => const [
      PostsState(status: PostsStatus.loading),
      PostsState(status: PostsStatus.success, posts: posts),
    ],
  );

  blocTest<PostsCubit, PostsState>(
    'emits [loading, failure] when the repository fails',
    setUp: () => when(
      () => repository.getPosts(),
    ).thenAnswer((_) async => const Left(ServerFailure('boom'))),
    build: () => PostsCubit(repository),
    act: (cubit) => cubit.loadPosts(),
    expect: () => const [
      PostsState(status: PostsStatus.loading),
      PostsState(status: PostsStatus.failure, errorMessage: 'boom'),
    ],
  );
}
