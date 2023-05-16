import 'package:authex/src/feature/session/data/session_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class SignInState {
  const SignInState();
}

final class SignInIdleState extends SignInState {
  const SignInIdleState();
}

final class SignInLoadingState extends SignInState {
  const SignInLoadingState();
}

final class SignInErrorState extends SignInState {
  const SignInErrorState(this.error);

  final Object error;
}

final class SignInSuccessState extends SignInState {
  const SignInSuccessState();
}

sealed class SignInEvent {
  const SignInEvent();
}

final class SignInEventSignIn extends SignInEvent {
  const SignInEventSignIn({required this.email, required this.password});

  final String email;
  final String password;
}

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc(this.repository) : super(const SignInIdleState()) {
    on<SignInEvent>(
      (event, emitter) => switch (event) {
        final SignInEventSignIn event => _signIn(event, emitter),
      },
    );
  }

  final ISessionRepository repository;

  Future<void> _signIn(SignInEventSignIn event, Emitter<SignInState> emitter) async {
    emitter(const SignInLoadingState());
    try {
      await Future<void>.delayed(const Duration(seconds: 2));
      await repository.signInWithCredentials(
        email: event.email,
        password: event.password,
      );
      emitter(const SignInSuccessState());
    } on Object catch (error) {
      emitter(SignInErrorState(error));
      rethrow;
    }
  }
}
