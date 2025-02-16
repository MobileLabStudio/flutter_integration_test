import 'package:flutter/material.dart';

class LocaleApp extends StatefulWidget {
  const LocaleApp({super.key});

  @override
  State<LocaleApp> createState() => _LocaleAppState();
}

class _LocaleAppState extends State<LocaleApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localeResolutionCallback: (locale, supportedLocales) {
        return locale;
      },
      home: Builder(
        builder: (context) {
          return Center(
            child: Text(Localizations.maybeLocaleOf(context)?.toString() ?? 'unknown'),
          );
        },
      ),
    );
  }
}
