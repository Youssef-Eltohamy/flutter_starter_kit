import 'package:flutter_starter_kit/core/config/app_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('defaults to the dev environment with a non-empty base URL', () {
    final config = AppConfig.fromEnvironment();

    expect(config.environment, AppEnvironment.dev);
    expect(config.baseUrl, isNotEmpty);
  });
}
