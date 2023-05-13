import 'package:authex/src/feature/home/widget/home_screen.dart';
import 'package:authex/src/feature/sign_in/widget/sign_in_screen.dart';
import 'package:authex/src/feature/sign_up/widget/sign_up_screen.dart';
import 'package:auto_route/auto_route.dart';

part 'router.gr.dart';

/// The configuration of app routes.
@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  AppRouter();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: HomeRoute.page,
          initial: true,
          path: '/',
        ),
        AutoRoute(
          page: SignUpRoute.page,
          path: '/signup',
        ),
        AutoRoute(
          page: SignInRoute.page,
          path: '/signin',
        ),
      ];
}
