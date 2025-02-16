import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../auto_route_app.gr.dart';

@RoutePage()
final class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: Center(
        child: FilledButton(
          onPressed: () async => context.router.push(const Screen2Route()),
          child: Text('Go to $Screen2'),
        ),
      ),
    );
  }
}

@RoutePage()
final class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: Center(
        child: FilledButton(
          onPressed: () async => context.router.push(const Screen3Route()),
          child: Text('Go to $Screen3'),
        ),
      ),
    );
  }
}

@RoutePage()
final class Screen3 extends StatelessWidget {
  const Screen3({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
