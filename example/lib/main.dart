// ignore_for_file: discarded_futures

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

final testURL = Uri.parse('http://localhost:8080/test');

void main() {
  runApp(const HttpClientExample());
}

class HttpClientExample extends StatefulWidget {
  const HttpClientExample({super.key});

  @override
  State<HttpClientExample> createState() => _HttpClientExampleState();
}

class _HttpClientExampleState extends State<HttpClientExample> {
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

class DioExample extends StatefulWidget {
  const DioExample({super.key});

  @override
  State<DioExample> createState() => _DioExampleState();
}

class _DioExampleState extends State<DioExample> {
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
