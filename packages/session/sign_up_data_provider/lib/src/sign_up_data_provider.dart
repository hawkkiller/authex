import 'package:rest_client/rest_client.dart';

typedef SignUpResponse = ({String accessToken, String refreshToken});
typedef SignUpCredentials = ({String email, String password});

abstract interface class ISignUpDataProvider {
  Future<SignUpResponse> signUp(SignUpCredentials credentials);
}

class SignUpDataProvider implements ISignUpDataProvider {
  SignUpDataProvider({
    required this.client,
  });

  final RestClient client;

  @override
  Future<SignUpResponse> signUp(SignUpCredentials credentials) async => (
    accessToken: 'access-token',
    refreshToken: 'refresh-token',
  );
}
