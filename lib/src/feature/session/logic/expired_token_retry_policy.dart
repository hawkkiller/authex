import 'package:authex/src/feature/session/data/refresh_client.dart';
import 'package:authex/src/feature/session/data/session_storage.dart';
import 'package:http_interceptor/models/response_data.dart';
import 'package:http_interceptor/models/retry_policy.dart';

class ExpiredTokenRetryPolicy extends RetryPolicy {
  ExpiredTokenRetryPolicy({
    required ISessionStorage sessionStorage,
    required IRefreshClient refreshClient,
  })  : _sessionStorage = sessionStorage,
        _refreshClient = refreshClient;

  final ISessionStorage _sessionStorage;
  final IRefreshClient _refreshClient;

  @override
  Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
    if (response.statusCode == 401) {
      // If the refresh fails, return false. If the refresh succeeds, return true.

      final token = await _sessionStorage.loadTokenPair();
      if (token == null) {
        await _sessionStorage.cleanTokenPair();
        return false;
      }

      final refreshedToken = await _refreshClient.refresh(token.refreshToken);

      await _sessionStorage.saveTokenPair(refreshedToken);

      return true;
    }

    return false;
  }
}
