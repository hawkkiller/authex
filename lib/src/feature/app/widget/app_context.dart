import 'package:authex/src/core/localization/app_localization.dart';
import 'package:authex/src/core/router/router.dart';
import 'package:authex/src/core/theme/color_schemes.dart';
import 'package:authex/src/feature/auth/widget/auth_scope.dart';
import 'package:flutter/material.dart';

/// A widget which is responsible for providing the app context.
class AppContext extends StatefulWidget {
  const AppContext({super.key});

  @override
  State<AppContext> createState() => _AppContextState();
}

class _AppContextState extends State<AppContext> {
  late final AppRouter router;
  late AuthScopeController authScopeController;

  @override
  void initState() {
    authScopeController = AuthScope.of(context, listen: false);
    router = AppRouter(authScopeController);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    authScopeController = AuthScope.of(context);
    // sort of a hack to prevent doing this thing
    // at the start, because of route guard.
    if (router.stack.isEmpty) return;
    if (authScopeController.isSignedIn) {
      router.replaceAll([const HomeRoute()]);
    }
    if (authScopeController.isSignedOut) {
      router.replaceAll([const SignInRoute()]);
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: authScopeController.firstState,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return MaterialApp.router(
            routerConfig: router.config(),
            supportedLocales: AppLocalization.supportedLocales,
            localizationsDelegates: AppLocalization.localizationsDelegates,
            theme: lightThemeData,
            darkTheme: darkThemeData,
            locale: const Locale('en'),
            title: 'AuthEx',
          );
        },
      );
}
