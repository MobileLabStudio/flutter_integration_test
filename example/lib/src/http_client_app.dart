// ignore_for_file: discarded_futures

import 'dart:async';
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
  bool showProgress = true;

  @override
  void initState() {
    super.initState();
    _httpClient = HttpClient();
    Timer(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          showProgress = false;
        });
      }
    });
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
          future: _httpClient.getUrl(testURL).then((request) async => request.close()).then((response) async {
            await Future.delayed(const Duration(seconds: 3));
            return utf8.decode(Uint8List.fromList(await response.first));
          }),
          builder: (context, snapshot) {
            return Column(
              children: [
                if (snapshot.data == null || showProgress) const CircularProgressIndicator(),
                Center(
                  child: Text(snapshot.data ?? ''),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
