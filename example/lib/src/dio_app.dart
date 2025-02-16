// ignore_for_file: discarded_futures

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class DioApp extends StatefulWidget {
  const DioApp({super.key});

  @override
  State<DioApp> createState() => _DioAppState();
}

class _DioAppState extends State<DioApp> {
  late final Dio dio;

  @override
  void initState() {
    super.initState();
    dio = Dio();
  }

  @override
  void dispose() {
    dio.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder(
          future: dio.getUri(testURL).then((response) => response.data),
          builder: (context, snapshot) {
            return Center(
              child: Text(snapshot.data ?? ''),
            );
          },
        ),
      ),
    );
  }
}
