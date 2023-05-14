import 'package:rest_client/rest_client.dart';
import 'package:session_repository/session_repository.dart';
import 'package:session_storage/session_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RepositoriesStore {
  const RepositoriesStore({
    required this.sessionRepository,
  });

  final ISessionRepository sessionRepository;
}

class DependenciesStore {
  const DependenciesStore({
    required this.preferences,
    required this.sessionStorage,
    required this.restClient,
  });

  final SharedPreferences preferences;
  final ISessionStorage sessionStorage;
  final RestClient restClient;
}

class InitializationProgress {
  const InitializationProgress({
    this.preferences,
    this.sessionRepository,
    this.sessionStorage,
    this.restClient,
  });

  final SharedPreferences? preferences;
  final ISessionRepository? sessionRepository;
  final ISessionStorage? sessionStorage;
  final RestClient? restClient;

  DependenciesStore dependencies() => DependenciesStore(
        preferences: preferences!,
        sessionStorage: sessionStorage!,
        restClient: restClient!,
      );

  RepositoriesStore repositories() => RepositoriesStore(
        sessionRepository: sessionRepository!,
      );

  InitializationProgress copyWith({
    SharedPreferences? preferences,
    ISessionRepository? sessionRepository,
    ISessionStorage? sessionStorage,
    RestClient? restClient,
  }) =>
      InitializationProgress(
        preferences: preferences ?? this.preferences,
        sessionRepository: sessionRepository ?? this.sessionRepository,
        sessionStorage: sessionStorage ?? this.sessionStorage,
        restClient: restClient ?? this.restClient,
      );
}

class InitializationResult {
  const InitializationResult({
    required this.dependencies,
    required this.repositories,
    required this.stepCount,
    required this.msSpent,
  });

  final DependenciesStore dependencies;
  final RepositoriesStore repositories;
  final int stepCount;
  final int msSpent;
}
