import 'package:flutter_starter_kit/core/router/app_router.dart';
import 'package:flutter_starter_kit/core/router/app_routes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  test('router exposes the expected routes', () {
    final paths = appRouter.configuration.routes
        .whereType<GoRoute>()
        .map((r) => r.path)
        .toList();

    expect(paths, contains(AppRoutes.posts));
    expect(paths, contains(AppRoutes.postDetails));
    expect(paths, contains(AppRoutes.onboarding));
  });

  test('postDetailsPath builds the expected location', () {
    expect(AppRoutes.postDetailsPath(7), '/posts/7');
  });
}
