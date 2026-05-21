/// The deployment environments the app can target.
enum AppEnvironment { dev, staging, prod }

/// Compile-time application configuration. Select an environment with
/// `--dart-define=ENV=dev|staging|prod` (defaults to `dev`). Replace the
/// placeholder base URLs with your real API endpoints.
class AppConfig {
  const AppConfig({required this.environment, required this.baseUrl});

  final AppEnvironment environment;
  final String baseUrl;

  factory AppConfig.fromEnvironment() {
    const env = String.fromEnvironment('ENV', defaultValue: 'dev');
    return switch (env) {
      'prod' => const AppConfig(
          environment: AppEnvironment.prod,
          baseUrl: 'https://api.example.com',
        ),
      'staging' => const AppConfig(
          environment: AppEnvironment.staging,
          baseUrl: 'https://api.staging.example.com',
        ),
      _ => const AppConfig(
          environment: AppEnvironment.dev,
          baseUrl: 'https://api.dev.example.com',
        ),
    };
  }
}
