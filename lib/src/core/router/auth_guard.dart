import 'package:authex/src/core/router/router.dart';
import 'package:authex/src/feature/auth/widget/auth_scope.dart';
import 'package:auto_route/auto_route.dart';

class NeedsAuthGuard extends AutoRouteGuard {
  const NeedsAuthGuard(this.source);

  final AuthSource source;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (source.isSignedIn) {
      resolver.next();
      return;
    }
    router.replaceAll([const SignInRoute()]);
  }
}

class NoAuthGuard extends AutoRouteGuard {
  const NoAuthGuard(this.source);

  final AuthSource source;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (source.isSignedIn) {
      router.replaceAll([const HomeRoute()]);
      return;
    }
    resolver.next();
  }
}
