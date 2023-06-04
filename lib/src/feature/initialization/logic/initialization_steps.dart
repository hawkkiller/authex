import 'dart:async';

import 'package:authex/src/core/utils/interceptor/logging_interceptor.dart';
import 'package:authex/src/feature/home/data/home_data_provider.dart';
import 'package:authex/src/feature/home/data/home_repository.dart';
import 'package:authex/src/feature/initialization/model/initialization_progress.dart';
import 'package:authex/src/feature/session/data/refresh_client.dart';
import 'package:authex/src/feature/session/data/session_repository.dart';
import 'package:authex/src/feature/session/data/session_storage.dart';
import 'package:authex/src/feature/session/data/sign_in_data_provider.dart';
import 'package:authex/src/feature/session/data/sign_up_data_provider.dart';
import 'package:authex/src/feature/session/logic/expired_token_retry_policy.dart';
import 'package:authex/src/feature/session/logic/oauth_token_interceptor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef StepAction = FutureOr<InitializationProgress>? Function(
  InitializationProgress progress,
);
mixin InitializationSteps {
  final initializationSteps = <String, StepAction>{
    ..._dependencies,
    ..._data,
  };
  static final _dependencies = <String, StepAction>{
    'Init Shared Preferences': (progress) async {
      final sharedPreferences = await SharedPreferences.getInstance();
      return progress.copyWith(
        preferences: sharedPreferences,
      );
    },
    'Init Session Storage': (progress) async {
      final sessionStorage = SessionStorage(
        storage: const FlutterSecureStorage(),
      );
      return progress.copyWith(
        sessionStorage: sessionStorage,
      );
    },
    'Init Rest Client': (progress) async {
      final interceptedClient = InterceptedClient.build(
        client: http.Client(),
        interceptors: [
          OAuthTokenInterceptor(progress.sessionStorage!),
          LoggingInterceptor(),
        ],
        retryPolicy: ExpiredTokenRetryPolicy(
          sessionStorage: progress.sessionStorage!,
          refreshClient: RefreshClient(
            baseUrl: 'https://example.com',
            client: http.Client(),
          ),
        ),
      );
      return progress.copyWith(restClient: interceptedClient);
    },
  };
  static final _data = <String, StepAction>{
    'Init Session Repository': (progress) {
      final sessionRepository = SessionRepository(
        sessionStorage: progress.sessionStorage!,
        signInDataProvider: SignInDataProvider(
          client: progress.restClient!,
        ),
        signUpDataProvider: SignUpDataProvider(
          client: progress.restClient!,
        ),
      );
      return progress.copyWith(
        sessionRepository: sessionRepository,
      );
    },
    'Init Home Repository': (progress) => progress.copyWith(
          homeRepository: HomeRepository(
            HomeDataProvider(progress.restClient!),
          ),
        ),
  };
}
