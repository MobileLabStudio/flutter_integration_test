import 'package:clock/clock.dart';
import 'package:flutter/material.dart';

class ClockApp extends StatefulWidget {
  const ClockApp({super.key});

  @override
  State<ClockApp> createState() => _ClockAppState();
}

class _ClockAppState extends State<ClockApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Center(
        child: Column(
          children: [
            FilledButton(
              onPressed: () {
                setState(() {});
              },
              child: const Text('Refresh'),
            ),
            Text(clock.now().toIso8601String()),
          ],
        ),
      ),
    );
  }
}
