import 'package:rest_client/rest_client.dart';

typedef SignInCredentials = ({String email, String password});
typedef SignInResponse = ({String accessToken, String refreshToken});

abstract interface class ISignInDataProvider {
  Future<SignInResponse> signIn(SignInCredentials credentials);
}

class SignInDataProvider implements ISignInDataProvider {
  SignInDataProvider({
    required this.client,
  });

  final RestClient client;

  @override
  Future<SignInResponse> signIn(SignInCredentials credentials) async => (
        accessToken: 'accessToken-${credentials.email}',
        refreshToken: 'refreshToken-${credentials.password}',
      );
}
