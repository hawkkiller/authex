abstract class IEnvironmentStore {
  abstract final String sentryDsn;
}

class EnvironmentStore extends IEnvironmentStore {
  EnvironmentStore();

  @override
  String get sentryDsn => const String.fromEnvironment('sentry_dsn');
}
