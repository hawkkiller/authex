import 'package:authex/src/core/utils/mixin/scope_mixin.dart';
import 'package:authex/src/feature/auth/bloc/auth_bloc.dart';
import 'package:authex/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract interface class AuthSource {
  bool get isSignedIn;

  bool get isSignedOut;

  Future<bool> get firstState;
}

abstract interface class AuthScopeController implements AuthSource {
  void signOut();
}

class AuthScope extends StatefulWidget {
  const AuthScope({
    required this.child,
    super.key,
  });

  final Widget child;

  static AuthScopeController of(
    BuildContext context, {
    bool listen = true,
  }) =>
      ScopeMixin.scopeOf<_AuthInherited>(context, listen: listen).controller;

  @override
  State<AuthScope> createState() => _AuthScopeState();
}

class _AuthScopeState extends State<AuthScope> implements AuthScopeController {
  late final AuthBloc authBloc;

  @override
  void initState() {
    authBloc = AuthBloc(
      sessionRepository: DependenciesScope.repositoriesOf(context).sessionRepository,
    )..add(const AuthEventLoad());
    super.initState();
  }

  @override
  void signOut() => authBloc.add(const AuthEventSignOut());

  @override
  bool get isSignedIn => authBloc.state.authenticated;

  @override
  bool get isSignedOut => authBloc.state.unauthenticated;

  @override
  late final Future<bool> firstState = authBloc.stream
      .firstWhere((state) => state.authenticated || state.unauthenticated)
      .then((value) => value.authenticated || value.unauthenticated);

  @override
  Widget build(BuildContext context) => BlocBuilder<AuthBloc, AuthState>(
        bloc: authBloc,
        builder: (context, state) => _AuthInherited(
          controller: this,
          child: widget.child,
        ),
      );
}

class _AuthInherited extends InheritedWidget {
  const _AuthInherited({
    required this.controller,
    required super.child,
  });

  final AuthScopeController controller;

  @override
  bool updateShouldNotify(_AuthInherited oldWidget) => true;
}
