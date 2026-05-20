import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_starter_kit/core/failures.dart';
import 'package:flutter_starter_kit/feature/example_posts/data/models/post.dart';
import 'package:flutter_starter_kit/feature/example_posts/data/posts_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late PostsRepository repository;

  setUp(() {
    dio = MockDio();
    repository = PostsRepository(dio);
  });

  Response<dynamic> response(dynamic data, {int status = 200}) => Response(
    data: data,
    statusCode: status,
    requestOptions: RequestOptions(path: ''),
  );

  test('returns a list of posts on success', () async {
    when(() => dio.get<dynamic>(any())).thenAnswer(
      (_) async => response([
        {'id': 1, 'title': 'a', 'body': 'b'},
      ]),
    );

    final result = await repository.getPosts();

    expect(result, isA<Right<Failure, List<Post>>>());
    expect(result.getOrElse(() => []), [
      const Post(id: 1, title: 'a', body: 'b'),
    ]);
  });

  test('returns ServerFailure on DioException', () async {
    when(
      () => dio.get<dynamic>(any()),
    ).thenThrow(DioException(requestOptions: RequestOptions(path: '')));

    final result = await repository.getPosts();

    expect(result, isA<Left<Failure, List<Post>>>());
    expect(
      result.swap().getOrElse(() => const CacheFailure()),
      isA<ServerFailure>(),
    );
  });

  test('returns NetworkFailure on connection error', () async {
    when(() => dio.get<dynamic>(any())).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionError,
      ),
    );

    final result = await repository.getPosts();

    expect(
      result.swap().getOrElse(() => const CacheFailure()),
      isA<NetworkFailure>(),
    );
  });
}
