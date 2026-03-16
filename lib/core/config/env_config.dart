/// Application environment configuration.
///
/// Initialize in `main()` before `runApp()`:
/// ```dart
/// EnvConfig.initialize(Environment.dev);
/// ```
library;

enum Environment {
  dev,
  staging,
  prod,
}

class EnvConfig {
  final Environment environment;
  final String baseUrl;
  final String appName;
  final bool enableLogging;

  const EnvConfig._({
    required this.environment,
    required this.baseUrl,
    required this.appName,
    required this.enableLogging,
  });

  static late final EnvConfig _instance;
  static EnvConfig get instance => _instance;
  static bool _initialized = false;

  /// Initialize the environment configuration. Must be called once in main().
  static void initialize(Environment env) {
    if (_initialized) return;

    switch (env) {
      case Environment.dev:
        _instance = const EnvConfig._(
          environment: Environment.dev,
          baseUrl: 'http://localhost:3000/api',
          appName: 'App [DEV]',
          enableLogging: true,
        );
      case Environment.staging:
        _instance = const EnvConfig._(
          environment: Environment.staging,
          baseUrl: 'https://api-staging.example.com/api',
          appName: 'App [STG]',
          enableLogging: true,
        );
      case Environment.prod:
        _instance = const EnvConfig._(
          environment: Environment.prod,
          baseUrl: 'https://api.example.com/api',
          appName: 'App',
          enableLogging: false,
        );
    }

    _initialized = true;
  }

  bool get isDev => environment == Environment.dev;
  bool get isStaging => environment == Environment.staging;
  bool get isProd => environment == Environment.prod;
}
