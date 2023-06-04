import 'package:authex/src/feature/home/data/home_repository.dart';
import 'package:authex/src/feature/session/data/session_repository.dart';
import 'package:authex/src/feature/session/data/session_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RepositoriesStore {
  const RepositoriesStore({
    required this.sessionRepository,
    required this.homeRepository,
  });

  final ISessionRepository sessionRepository;
  final IHomeRepository homeRepository;
}

class DependenciesStore {
  const DependenciesStore({
    required this.preferences,
    required this.sessionStorage,
    required this.restClient,
  });

  final SharedPreferences preferences;
  final ISessionStorage sessionStorage;
  final http.Client restClient;
}

class InitializationProgress {
  const InitializationProgress({
    this.preferences,
    this.sessionRepository,
    this.sessionStorage,
    this.homeRepository,
    this.restClient,
  });

  final SharedPreferences? preferences;
  final ISessionRepository? sessionRepository;
  final ISessionStorage? sessionStorage;
  final IHomeRepository? homeRepository;
  final http.Client? restClient;

  DependenciesStore dependencies() => DependenciesStore(
        preferences: preferences!,
        sessionStorage: sessionStorage!,
        restClient: restClient!,
      );

  RepositoriesStore repositories() => RepositoriesStore(
        sessionRepository: sessionRepository!,
        homeRepository: homeRepository!,
      );

  InitializationProgress copyWith({
    SharedPreferences? preferences,
    ISessionRepository? sessionRepository,
    ISessionStorage? sessionStorage,
    IHomeRepository? homeRepository,
    http.Client? restClient,
  }) =>
      InitializationProgress(
        preferences: preferences ?? this.preferences,
        sessionRepository: sessionRepository ?? this.sessionRepository,
        sessionStorage: sessionStorage ?? this.sessionStorage,
        restClient: restClient ?? this.restClient,
        homeRepository: homeRepository ?? this.homeRepository,
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
