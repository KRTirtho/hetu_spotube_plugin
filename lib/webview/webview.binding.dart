import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hetu_script/binding.dart';
import 'package:hetu_script/hetu_script.dart';
import 'package:hetu_spotube_plugin/webview/webview.dart';
import 'package:hetu_std/hetu_std.dart' as std;

extension CookieBinding on Cookie {
  dynamic htFetch(String id) {
    return switch (id) {
      "name" => name,
      "value" => value,
      "domain" => domain,
      "expiresDate" => expiresDate,
      "isHttpOnly" => isHttpOnly,
      "isSecure" => isSecure,
      "isSessionOnly" => isSessionOnly,
      "path" => path,
      "toJson" => (
        HTEntity entity, {
        List<dynamic> positionalArgs = const [],
        Map<String, dynamic> namedArgs = const {},
        List<HTType> typeArgs = const [],
      }) {
        return toJson();
      },
      _ => throw HTError.undefined(id),
    };
  }
}

class CookieClassBinding extends HTExternalClass {
  CookieClassBinding() : super("Cookie");

  @override
  dynamic memberGet(String varName, {String? from}) {
    return switch (varName) {
      "Cookie" => (
        HTEntity entity, {
        List<dynamic> positionalArgs = const [],
        Map<String, dynamic> namedArgs = const {},
        List<HTType> typeArgs = const [],
      }) {
        return Cookie(
          name: namedArgs['name'],
          value: namedArgs['value'],
          domain: namedArgs['domain'],
          expiresDate: namedArgs['expiresDate'],
          isHttpOnly: namedArgs['isHttpOnly'],
          isSecure: namedArgs['isSecure'],
          isSessionOnly: namedArgs['isSessionOnly'],
          path: namedArgs['path'],
        );
      },
      "Cookie.fromJson" => (
        HTEntity entity, {
        List<dynamic> positionalArgs = const [],
        Map<String, dynamic> namedArgs = const {},
        List<HTType> typeArgs = const [],
      }) {
        return Cookie.fromMap(positionalArgs[0]);
      },
      _ => HTError.undefined(varName),
    };
  }

  @override
  instanceMemberGet(object, String varName) =>
      (object as Cookie).htFetch(varName);
}

extension WebviewBinding on Webview {
  dynamic htFetch(String id) {
    return switch (id) {
      "open" =>
        (
          HTEntity entity, {
          List<dynamic> positionalArgs = const [],
          Map<String, dynamic> namedArgs = const {},
          List<HTType> typeArgs = const [],
        }) => open(),
      "close" =>
        (
          HTEntity entity, {
          List<dynamic> positionalArgs = const [],
          Map<String, dynamic> namedArgs = const {},
          List<HTType> typeArgs = const [],
        }) => close(),
      "getCookies" =>
        (
          HTEntity entity, {
          List<dynamic> positionalArgs = const [],
          Map<String, dynamic> namedArgs = const {},
          List<HTType> typeArgs = const [],
        }) => getCookies(positionalArgs[0]),
      "onUrlRequestStream" => std.Stream(onUrlRequestStream),
      _ => throw HTError.undefined(id),
    };
  }
}

class WebviewClassBinding extends HTExternalClass {
  final FutureOr Function(Widget route) onNavigatorPush;
  final FutureOr<void> Function() onNavigatorPop;

  WebviewClassBinding({
    required this.onNavigatorPush,
    required this.onNavigatorPop,
  }) : super("Webview");

  @override
  dynamic memberGet(String varName, {String? from}) {
    return switch (varName) {
      "Webview" =>
        (
          HTEntity entity, {
          List<dynamic> positionalArgs = const [],
          Map<String, dynamic> namedArgs = const {},
          List<HTType> typeArgs = const [],
        }) => Webview(
          onNavigatorPush: onNavigatorPush,
          onNavigatorPop: onNavigatorPop,
          uri: namedArgs['uri'],
        ),
      _ => HTError.undefined(varName),
    };
  }

  @override
  instanceMemberGet(object, String varName) =>
      (object as Webview).htFetch(varName);
}
