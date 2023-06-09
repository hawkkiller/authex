import 'package:authex/src/core/router/router.dart';
import 'package:authex/src/core/utils/extensions/context_extension.dart';
import 'package:authex/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:authex/src/feature/session/bloc/sign_in_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String email = '';
  String password = '';

  bool fieldsEmpty() => email.isEmpty || password.isEmpty;

  void signIn() {
    signInBloc.add(
      SignInEventSignIn(
        email: email,
        password: password,
      ),
    );
  }

  late final SignInBloc signInBloc;

  @override
  void initState() {
    signInBloc = SignInBloc(
      DependenciesScope.repositoriesOf(context).sessionRepository,
    );
    super.initState();
  }

  @override
  void dispose() {
    signInBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<SignInBloc, SignInState>(
        bloc: signInBloc,
        listener: (context, state) {
          if (state case SignInSuccessState()) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  context.stringOf().sign_in_success,
                ),
              ),
            );
          }
        },
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text(
              context.stringOf().sign_in,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500,
                maxHeight: 500,
              ),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextField(
                    onChanged: (value) => setState(() => email = value),
                    decoration: InputDecoration(
                      labelText: context.stringOf().email,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 16,
                    ),
                    child: TextField(
                      onChanged: (value) => setState(() => password = value),
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: context.stringOf().password,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: ElevatedButton(
                      onPressed: fieldsEmpty() || state.isLoading ? null : signIn,
                      child: state.isLoading
                          ? const CircularProgressIndicator.adaptive()
                          : Text(
                              context.stringOf().sign_in,
                            ),
                    ),
                  ),
                  if (!state.isLoading)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Center(
                        child: TextButton(
                          onPressed: () => context.router.push(const SignUpRoute()),
                          child: Text(
                            context.stringOf().have_no_account_register,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
}
