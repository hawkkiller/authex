import 'dart:async';

import 'package:authex/src/feature/initialization/model/initialization_progress.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rest_client/rest_client.dart';
import 'package:session_repository/session_repository.dart';
import 'package:session_storage/session_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_data_provider/sign_in_data_provider.dart';
import 'package:sign_up_data_provider/sign_up_data_provider.dart';

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
      final restClient = RestClient(baseUrl: 'https://example.com');
      return progress.copyWith(
        restClient: restClient,
      );
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
  };
}
