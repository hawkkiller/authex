import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:session_repository/session_repository.dart';

sealed class SignUpState {
  const SignUpState();
}

final class SignUpIdleState extends SignUpState {
  const SignUpIdleState();
}

final class SignUpLoadingState extends SignUpState {
  const SignUpLoadingState();
}

final class SignUpErrorState extends SignUpState {
  const SignUpErrorState(this.error);

  final Object error;
}

final class SignUpSuccessState extends SignUpState {
  const SignUpSuccessState();
}

sealed class SignUpEvent {
  const SignUpEvent();
}

final class SignUpEventSignUp extends SignUpEvent {
  const SignUpEventSignUp({required this.email, required this.password});

  final String email;
  final String password;
}

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc(this.repository) : super(const SignUpIdleState()) {
    on<SignUpEvent>(
      (event, emitter) => switch (event) {
        final SignUpEventSignUp event => _signUp(event, emitter),
      },
    );
  }

  final ISessionRepository repository;

  Future<void> _signUp(SignUpEventSignUp event, Emitter<SignUpState> emitter) async {
    emitter(const SignUpLoadingState());
    try {
      await Future<void>.delayed(const Duration(seconds: 2));
      await repository.signUp(
        email: event.email,
        password: event.password,
      );
      emitter(const SignUpSuccessState());
    } on Object catch (error) {
      emitter(SignUpErrorState(error));
      rethrow;
    }
  }
}
