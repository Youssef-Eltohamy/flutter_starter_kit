import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/core/failures.dart';
import 'package:flutter_starter_kit/feature/example_posts/data/models/post.dart';
import 'package:flutter_starter_kit/feature/example_posts/data/posts_repository.dart';
import 'package:flutter_starter_kit/feature/example_posts/presentation/screen/posts_screen.dart';
import 'package:flutter_starter_kit/injection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../support/pump_app.dart';

class MockPostsRepository extends Mock implements PostsRepository {}

void main() {
  late MockPostsRepository repository;

  setUp(() {
    repository = MockPostsRepository();
    getIt.registerFactory<PostsRepository>(() => repository);
  });

  tearDown(() => getIt.reset());

  testWidgets('shows a loading indicator while posts load', (tester) async {
    when(() => repository.getPosts()).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      return const Right<Failure, List<Post>>([]);
    });

    await tester.pumpApp(const PostsScreen());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
  });

  testWidgets('renders posts on success', (tester) async {
    when(() => repository.getPosts()).thenAnswer(
      (_) async => const Right<Failure, List<Post>>([
        Post(id: 1, title: 'Hello', body: 'World'),
      ]),
    );

    await tester.pumpApp(const PostsScreen());
    await tester.pumpAndSettle();

    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('World'), findsOneWidget);
  });

  testWidgets('shows error + retry on failure, and retry refetches', (
    tester,
  ) async {
    when(() => repository.getPosts()).thenAnswer(
      (_) async => const Left<Failure, List<Post>>(ServerFailure('Boom')),
    );

    await tester.pumpApp(const PostsScreen());
    await tester.pumpAndSettle();

    expect(find.text('Boom'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    verify(() => repository.getPosts()).called(2);
  });
}
