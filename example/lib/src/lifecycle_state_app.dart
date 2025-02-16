import 'package:flutter/material.dart';

class LifecycleStateApp extends StatefulWidget {
  const LifecycleStateApp({super.key});

  @override
  State<LifecycleStateApp> createState() => _LifecycleStateAppState();
}

class _LifecycleStateAppState extends State<LifecycleStateApp> with WidgetsBindingObserver {
  late AppLifecycleState? lifecycleState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    lifecycleState = WidgetsBinding.instance.lifecycleState;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    setState(() {
      lifecycleState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Center(
        child: Text(lifecycleState?.toString() ?? 'unknown'),
      ),
    );
  }
}
