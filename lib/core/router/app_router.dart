import 'package:flutter_starter_kit/core/router/app_routes.dart';
import 'package:flutter_starter_kit/feature/example_posts/data/models/post.dart';
import 'package:flutter_starter_kit/feature/example_posts/presentation/screen/post_details_screen.dart';
import 'package:flutter_starter_kit/feature/example_posts/presentation/screen/posts_screen.dart';
import 'package:flutter_starter_kit/feature/on_boarding/widgets/onboarding_screen.dart';
import 'package:go_router/go_router.dart';

/// The single source of truth for app navigation.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.posts,
  routes: [
    GoRoute(
      path: AppRoutes.posts,
      name: AppRoutes.postsName,
      builder: (context, state) => const PostsScreen(),
    ),
    GoRoute(
      path: AppRoutes.postDetails,
      name: AppRoutes.postDetailsName,
      builder: (context, state) =>
          PostDetailsScreen(post: state.extra as Post?),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      name: AppRoutes.onboardingName,
      builder: (context, state) => const OnboardingScreen(),
    ),
  ],
);
