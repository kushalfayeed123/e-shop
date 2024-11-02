import 'package:eshop/presentation/auth/login.dart';
import 'package:eshop/presentation/dashboard/dashboard.dart';
import 'package:eshop/presentation/orders/orders.dart';
import 'package:eshop/presentation/products/product_list.dart';
import 'package:eshop/presentation/shared/app_layout.dart';
import 'package:eshop/presentation/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider.autoDispose<GoRouter>((ref) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  final shellNavigatorHomeKey =
      GlobalKey<NavigatorState>(debugLabel: 'dashboardShell');
  final shellNavigatorMapKey =
      GlobalKey<NavigatorState>(debugLabel: 'orderShell');
  final shellNavigatorChatKey =
      GlobalKey<NavigatorState>(debugLabel: 'inventoryShell');
  final shellNavigatorFavoriteKey =
      GlobalKey<NavigatorState>(debugLabel: 'settingsShell');

  final router =
      GoRouter(initialLocation: '/', navigatorKey: rootNavigatorKey, routes: [
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
            key: UniqueKey(),
            child: const Splash(),
            reverseTransitionDuration: const Duration(seconds: 1),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: animation.drive(
                  Tween<Offset>(
                    begin: const Offset(0.75, 0),
                    end: Offset.zero,
                  ).chain(CurveTween(curve: Curves.easeIn)),
                ),
                child: child,
              );
            });
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/login',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
            key: UniqueKey(),
            child: const LoginScreen(),
            reverseTransitionDuration: const Duration(seconds: 1),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: animation.drive(
                  Tween<Offset>(
                    begin: const Offset(0.75, 0),
                    end: Offset.zero,
                  ).chain(CurveTween(curve: Curves.easeIn)),
                ),
                child: child,
              );
            });
      },
    ),
    StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppLayout(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(navigatorKey: shellNavigatorMapKey, routes: [
            GoRoute(
              path: '/dashboard',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                    key: UniqueKey(),
                    child: const DashboardScreen(),
                    transitionDuration: const Duration(seconds: 1),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: animation.drive(
                          Tween<Offset>(
                            begin: const Offset(0.75, 0),
                            end: Offset.zero,
                          ).chain(CurveTween(curve: Curves.easeIn)),
                        ),
                        child: child,
                      );
                    });
              },
            ),
          ]),
          StatefulShellBranch(navigatorKey: shellNavigatorChatKey, routes: [
            GoRoute(
              path: '/orders',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                    key: UniqueKey(),
                    child: const OrdersScreen(),
                    transitionDuration: const Duration(seconds: 1),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: animation.drive(
                          Tween<Offset>(
                            begin: const Offset(0.75, 0),
                            end: Offset.zero,
                          ).chain(CurveTween(curve: Curves.easeIn)),
                        ),
                        child: child,
                      );
                    });
              },
            ),
          ]),
          StatefulShellBranch(navigatorKey: shellNavigatorHomeKey, routes: [
            GoRoute(
              path: '/inventory',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                    key: UniqueKey(),
                    child: const ProductList(),
                    transitionDuration: const Duration(seconds: 1),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: animation.drive(
                          Tween<Offset>(
                            begin: const Offset(0.75, 0),
                            end: Offset.zero,
                          ).chain(CurveTween(curve: Curves.easeIn)),
                        ),
                        child: child,
                      );
                    });
              },
            ),
          ]),
          StatefulShellBranch(navigatorKey: shellNavigatorFavoriteKey, routes: [
            GoRoute(
              path: '/settings',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                    key: UniqueKey(),
                    child: const SizedBox(),
                    transitionDuration: const Duration(seconds: 1),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                          position: animation.drive(Tween<Offset>(
                        begin: const Offset(0.75, 0),
                        end: Offset.zero,
                      ).chain(CurveTween(curve: Curves.easeIn))));
                    });
              },
            ),
          ]),
        ]),
  ]);
  return router;
});
