import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:l/l.dart';

typedef TokenPair = ({String accessToken, String refreshToken});

/// Interface for session storage.
///
/// Exposes methods to save and load [TokenPair] model.
abstract interface class ISessionStorage {
  Stream<TokenPair?> get tokenPairStream;

  Future<TokenPair?> loadTokenPair();

  Future<void> saveTokenPair(TokenPair tokenPair);

  Future<void> cleanTokenPair();

  Future<void> close();
}

final class SessionStorage implements ISessionStorage {
  SessionStorage({
    required FlutterSecureStorage storage,
  }) : _storage = storage;

  final controller = StreamController<TokenPair?>.broadcast();

  final FlutterSecureStorage _storage;

  static const _prefix = 'session_storage';
  static const _accessToken = '$_prefix.token.access';
  static const _refreshToken = '$_prefix.token.refresh';

  final _cache = AsyncCache<TokenPair?>.ephemeral();

  @override
  Future<TokenPair?> loadTokenPair() async => _cache.fetch(
        () async {
          final accessToken = await _storage.read(key: _accessToken);
          final refreshToken = await _storage.read(key: _refreshToken);

          if (refreshToken == null || accessToken == null) {
            return null;
          }

          final tokenPair = (
            accessToken: accessToken,
            refreshToken: refreshToken,
          );

          return tokenPair;
        },
      );

  @override
  Future<void> saveTokenPair(TokenPair tokenPair) async {
    await _storage.write(
      key: _accessToken,
      value: tokenPair.accessToken,
    );
    await _storage.write(
      key: _refreshToken,
      value: tokenPair.refreshToken,
    );
    controller.add(tokenPair);
  }

  @override
  Future<void> cleanTokenPair() async {
    await _storage.deleteAll();
    controller.add(null);
  }

  @override
  Future<void> close() => controller.close();

  @override
  Stream<TokenPair?> get tokenPairStream => controller.stream;
}
