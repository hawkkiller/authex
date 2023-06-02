import 'package:authex/src/feature/session/data/session_storage.dart';
import 'package:http_interceptor/http_interceptor.dart';

class OAuthTokenInterceptor implements InterceptorContract {
  OAuthTokenInterceptor(this._sessionStorage);

  final ISessionStorage _sessionStorage;

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    final token = await _sessionStorage.loadTokenPair();
    if (token != null) {
      data.headers['Authorization'] = 'Bearer ${token.accessToken}';
    }

    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async => data;
}
