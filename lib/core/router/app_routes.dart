/// Centralized route paths and names. Reference these instead of string
/// literals when navigating.
abstract final class AppRoutes {
  static const posts = '/';
  static const postsName = 'posts';

  static const postDetails = '/posts/:id';
  static const postDetailsName = 'postDetails';

  static const onboarding = '/onboarding';
  static const onboardingName = 'onboarding';

  static String postDetailsPath(int id) => '/posts/$id';
}
