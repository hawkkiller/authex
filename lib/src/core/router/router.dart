import 'package:authex/src/core/router/auth_guard.dart';
import 'package:authex/src/feature/auth/widget/auth_scope.dart';
import 'package:authex/src/feature/home/widget/home_screen.dart';
import 'package:authex/src/feature/session/widget/sign_in_screen.dart';
import 'package:authex/src/feature/session/widget/sign_up_screen.dart';
import 'package:auto_route/auto_route.dart';

part 'router.gr.dart';

/// The configuration of app routes.
@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  AppRouter(this.source);

  final AuthSource source;

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: HomeRoute.page,
          initial: true,
          path: '/',
          guards: [
            NeedsAuthGuard(source),
          ],
        ),
        AutoRoute(
          page: SignUpRoute.page,
          path: '/signup',
          guards: [
            NoAuthGuard(source),
          ],
        ),
        AutoRoute(
          page: SignInRoute.page,
          path: '/signin',
          guards: [
            NoAuthGuard(source),
          ],
        ),
      ];
}
