import 'dart:convert';

import 'package:authex/src/feature/session/data/session_storage.dart';

const $tokenPairCodec = TokenPairCodec();

final class TokenPairCodec with Codec<TokenPair, String> {
  const TokenPairCodec();

  @override
  Converter<String, TokenPair> get decoder => const _TokenPairDecoder();

  @override
  Converter<TokenPair, String> get encoder => const _TokenPairEncoder();
}

final class _TokenPairDecoder with Converter<String, TokenPair> {
  const _TokenPairDecoder();

  @override
  TokenPair convert(String input) {
    final json = jsonDecode(input) as Map<String, Object?>;
    return (
      accessToken: json['access_token']! as String,
      refreshToken: json['refresh_token']! as String,
    );
  }
}

final class _TokenPairEncoder with Converter<TokenPair, String> {
  const _TokenPairEncoder();

  @override
  String convert(TokenPair input) => jsonEncode({
        'access_token': input.accessToken,
        'refresh_token': input.refreshToken,
      });
}
