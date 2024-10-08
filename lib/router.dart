import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import 'package:ai_poem_app/screens/first_screen.dart';
import 'package:ai_poem_app/screens/second_screen.dart';
import 'package:ai_poem_app/screens/new_poem_screen.dart';
import 'package:ai_poem_app/screens/edit_poems_screen.dart';

/// Shared paths / urls used across the app
class ScreenPaths {
  static String splash = '/';
  static String home = '/home';
  static String imageDetails(String id) => '/details/$id';
  static String createPoem = "/createPoem";
  static String updatePoem(String id) => "/updatePoem/$id";
  static String editPoems = '/editPoems';
  static String infiniteScroll = "/infiniteScroll";
}

/// Routing table, matches string paths to UI Screens
final appRouter = GoRouter(
  routes: [
    AppRoute(ScreenPaths.splash,
        (_) => Container(color: Colors.grey)), // This will be hidden
    AppRoute(ScreenPaths.home, (_) => const HomeScreen()),
    AppRoute('/details/:id', (s) {
      String id = s.pathParameters['id'] ?? '';
      return SecondScreen(id: id);
    }, useFade: true),
    AppRoute(ScreenPaths.editPoems, (s) => const EditPoems()),
    AppRoute(ScreenPaths.createPoem, (s) => const NewPoem(id: null)),
    AppRoute('/updatePoem/:id', (s) {
      String id = s.pathParameters['id'] ?? '';
      return NewPoem(id: id);
    }, useFade: true),
  ],
);

/// Custom GoRoute sub-class to make the router declaration easier to read
class AppRoute extends GoRoute {
  AppRoute(String path, Widget Function(GoRouterState s) builder,
      {List<GoRoute> routes = const [], this.useFade = false})
      : super(
          path: path,
          routes: routes,
          pageBuilder: (context, state) {
            final pageContent = Scaffold(
              body: builder(state),
              resizeToAvoidBottomInset: false,
            );
            if (useFade) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: pageContent,
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              );
            }
            return CupertinoPage(child: pageContent);
          },
        );
  final bool useFade;
}
