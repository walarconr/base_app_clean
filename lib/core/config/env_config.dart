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
  final String apiKey;

  const EnvConfig._({
    required this.environment,
    required this.baseUrl,
    required this.appName,
    required this.enableLogging,
    required this.apiKey,
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
          baseUrl: 'http://10.0.2.2:8007/api',
          appName: 'Omnicore [DEV]',
          enableLogging: true,
          apiKey: 'pk_b4ec0777b88b1312f2bffb4cbc3b2c4a93dbaf93073fc8dd',
        );
      case Environment.staging:
        _instance = const EnvConfig._(
          environment: Environment.staging,
          baseUrl: 'https://tu-dominio.com/api',
          appName: 'Omnicore [STG]',
          enableLogging: true,
          apiKey: 'pk_tu_llave_publica',
        );
      case Environment.prod:
        _instance = const EnvConfig._(
          environment: Environment.prod,
          baseUrl: 'https://tu-dominio.com/api',
          appName: 'Omnicore',
          enableLogging: false,
          apiKey: 'pk_tu_llave_publica',
        );
    }

    _initialized = true;
  }

  bool get isDev => environment == Environment.dev;
  bool get isStaging => environment == Environment.staging;
  bool get isProd => environment == Environment.prod;
}
