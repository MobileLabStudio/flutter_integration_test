// ignore_for_file: discarded_futures

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';

class HttpClientApp extends StatefulWidget {
  const HttpClientApp({super.key});

  @override
  State<HttpClientApp> createState() => _HttpClientAppState();
}

class _HttpClientAppState extends State<HttpClientApp> {
  late final HttpClient _httpClient;

  @override
  void initState() {
    super.initState();
    _httpClient = HttpClient();
  }

  @override
  void dispose() {
    _httpClient.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder(
          future: _httpClient
              .getUrl(testURL)
              .then((request) async => request.close())
              .then((response) async => utf8.decode(Uint8List.fromList(await response.first))),
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
