import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_starter_kit/core/failures.dart';
import 'package:flutter_starter_kit/feature/example_posts/data/models/post.dart';

/// Fetches example posts from a public API. Demonstrates the project's
/// data-layer pattern: take a [Dio], return `Either<Failure, T>`, and map
/// transport errors to typed [Failure]s.
///
/// For simplicity this example uses a standalone [Dio] against a public test
/// API (jsonplaceholder). Real features that need auth headers, a configured
/// base URL, or interceptors should use the project's `DioApiManager` instead
/// — environment/base-URL wiring is covered in a later phase.
class PostsRepository {
  const PostsRepository(this._dio);

  final Dio _dio;

  static const _endpoint =
      'https://jsonplaceholder.typicode.com/posts?_limit=20';

  Future<Either<Failure, List<Post>>> getPosts() async {
    try {
      final response = await _dio.get<dynamic>(_endpoint);
      final data = (response.data as List<dynamic>?) ?? <dynamic>[];
      final posts =
          data.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
      return Right(posts);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        return const Left(NetworkFailure());
      }
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (_) {
      return const Left(ServerFailure());
    }
  }
}
