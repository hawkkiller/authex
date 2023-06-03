import 'package:authex/src/feature/session/data/session_storage.dart';
import 'package:authex/src/feature/session/logic/token_pair_codec.dart';
import 'package:http/http.dart' as http;

abstract interface class IRefreshClient {
  Future<TokenPair> refresh(String refreshToken);
}

final class RefreshClient implements IRefreshClient {
  RefreshClient({
    required String baseUrl,
    http.Client? client,
  })  : _client = client ?? http.Client(),
        _baseUri = Uri.parse(baseUrl);

  final http.Client _client;
  final Uri _baseUri;

  @override
  Future<TokenPair> refresh(String refreshToken) {
    final uri = _baseUri.replace(
      path: '/oauth/token',
      queryParameters: {
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
      },
    );

    return _client.post(
      uri,
      headers: {'Accept': 'application/json'},
    ).then((response) => $tokenPairCodec.decoder.convert(response.body));
  }
}
