import 'dart:async';

import 'package:session_storage/session_storage.dart';
import 'package:sign_in_data_provider/sign_in_data_provider.dart';
import 'package:sign_up_data_provider/sign_up_data_provider.dart';

abstract interface class CloseableRepository {
  Future<void> close();
}

abstract interface class ISessionRepository implements CloseableRepository {
  /// Removes tokens from the storage.
  Future<void> signOut();

  /// Asynchronous stream of tokens.
  ///
  /// If user is signed in, emits [TokenPair] instance.
  ///
  /// If user is not signed in, emits `null`.
  ///
  /// If user signs out, emits `null`.
  Stream<TokenPair?> get tokensStream;

  /// Loads tokens from the storage.
  /// Returns `null` if there are no tokens in the storage.
  Future<TokenPair?> loadTokens();

  /// Sends signIn request to the server, saves tokens in case of success.
  Future<TokenPair> signInWithCredentials({
    required String email,
    required String password,
  });

  /// Sends signUp request to the server, saves tokens in case of success.
  Future<TokenPair> signUp({
    required String email,
    required String password,
  });
}

final class SessionRepository implements ISessionRepository {
  SessionRepository({
    required ISessionStorage sessionStorage,
    required ISignInDataProvider signInDataProvider,
    required ISignUpDataProvider signUpDataProvider,
  })  : _sessionStorage = sessionStorage,
        _signInDataProvider = signInDataProvider,
        _signUpDataProvider = signUpDataProvider;

  final ISessionStorage _sessionStorage;
  final ISignInDataProvider _signInDataProvider;
  final ISignUpDataProvider _signUpDataProvider;

  @override
  Future<void> close() async {
    await _sessionStorage.close();
  }

  Future<void> _saveTokenPair(TokenPair tokenPair) => _sessionStorage.saveTokenPair(tokenPair);

  Future<void> _cleanTokenPair() => _sessionStorage.cleanTokenPair();

  @override
  Future<TokenPair?> loadTokens() => _sessionStorage.loadTokenPair();

  @override
  Stream<TokenPair?> get tokensStream => _sessionStorage.tokenPairStream;

  @override
  Future<TokenPair> signInWithCredentials({
    required String email,
    required String password,
  }) async {
    final response = await _signInDataProvider.signIn(
      (email: email, password: password),
    );
    final tokenPair = (
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
    await _saveTokenPair(tokenPair);
    return tokenPair;
  }

  @override
  Future<void> signOut() => _cleanTokenPair();

  @override
  Future<TokenPair> signUp({
    required String email,
    required String password,
  }) async {
    final response = await _signUpDataProvider.signUp(
      (email: email, password: password),
    );

    final tokenPair = (
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );

    await _saveTokenPair(tokenPair);
    return tokenPair;
  }
}
