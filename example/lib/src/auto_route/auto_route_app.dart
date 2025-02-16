import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'auto_route_app.gr.dart';

class AutoRouteApp extends StatefulWidget {
  const AutoRouteApp({super.key});

  @override
  State<AutoRouteApp> createState() => _AutoRouteAppState();
}

class _AutoRouteAppState extends State<AutoRouteApp> {
  late _Router router;

  @override
  void initState() {
    super.initState();
    router = _Router();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router.config(),
    );
  }
}

@AutoRouterConfig(replaceInRouteName: 'Screen|ScreenRoute')
final class _Router extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(path: '/screen1', page: Screen1Route.page, initial: true),
        AutoRoute(path: '/screen2', page: Screen2Route.page),
        AutoRoute(path: '/screen3', page: Screen3Route.page),
      ];
}
