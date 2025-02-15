import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:shelf/shelf.dart';

@immutable
final class FakeHttpResponse {
  const FakeHttpResponse({
    required this.method,
    required this.pattern,
    required this.statusCode,
    this.response,
    this.headers,
    this.encoding,
    this.context,
  });

  final String method;
  final RegExp pattern;
  final int statusCode;
  final Object? response;
  final Map<String, /* String | List<String> */ Object>? headers;
  final Encoding? encoding;
  final Map<String, Object>? context;

  bool hasMatchInRequest(Request request) => request.method == method && hasMatchInUrl(request.url);

  bool hasMatchInUrl(Uri url) => pattern.hasMatch(url.toString());

  @override
  int get hashCode => Object.hashAll([
        method,
        pattern,
        statusCode,
        response,
        headers,
        encoding,
        context,
      ]);

  @override
  bool operator ==(Object other) => other is FakeHttpResponse && other.hashCode == hashCode;
}
