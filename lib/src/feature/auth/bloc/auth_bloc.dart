import 'package:authex/src/core/utils/mixin/setstate_mixin.dart';
import 'package:authex/src/feature/session/data/session_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class AuthState {
  const AuthState();

  bool get authenticated => switch (this) {
    AuthStateAuthenticated() => true,
    _ => false,
  };

  bool get unauthenticated => switch (this) {
    AuthStateUnauthenticated() => true,
    _ => false,
  };
}

class AuthStateIdle extends AuthState {
  const AuthStateIdle();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateAuthenticated extends AuthState {
  const AuthStateAuthenticated();
}

class AuthStateUnauthenticated extends AuthState {
  const AuthStateUnauthenticated();
}

sealed class AuthEvent {
  const AuthEvent();
}

class AuthEventLoad extends AuthEvent {
  const AuthEventLoad();
}

class AuthEventSignOut extends AuthEvent {
  const AuthEventSignOut();
}

class AuthBloc extends Bloc<AuthEvent, AuthState> with StateSetterMixin {
  AuthBloc({
    required ISessionRepository sessionRepository,
  })  : _sessionRepository = sessionRepository,
        super(const AuthStateIdle()) {
    on<AuthEvent>(
      (event, emit) => switch (event) {
        final AuthEventLoad event => _load(event, emit),
        final AuthEventSignOut event => _signOut(event, emit),
      },
    );
    _sessionRepository.tokensStream.listen((tokenPair) {
      if (_isTokenValid(tokenPair?.refreshToken)) {
        setState(const AuthStateAuthenticated());
      } else {
        setState(const AuthStateUnauthenticated());
      }
    });
  }

  bool _isTokenValid(String? token) => token != null && token.isNotEmpty;

  final ISessionRepository _sessionRepository;

  Future<void> _load(
    AuthEventLoad event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthStateLoading());
      final tokenPair = await _sessionRepository.loadTokens();
      // if token pair is not [null] and refresh token
      // is not empty then we are authenticated
      if (_isTokenValid(tokenPair?.refreshToken)) {
        emit(const AuthStateAuthenticated());
      } else {
        emit(const AuthStateUnauthenticated());
      }
    } on Object catch (_) {
      // TODO(mlazebny): think if it is correct
      emit(const AuthStateUnauthenticated());
      rethrow;
    }
  }

  Future<void> _signOut(
    AuthEventSignOut event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthStateLoading());
      await _sessionRepository.signOut();
      emit(const AuthStateUnauthenticated());
    } on Object catch (_) {
      // TODO(mlazebny): think if it is correct
      emit(const AuthStateUnauthenticated());
      rethrow;
    }
  }
}
