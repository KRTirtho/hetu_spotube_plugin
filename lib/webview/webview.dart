import 'dart:async';
import 'dart:io';

import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart'
    as webview_window;
import 'package:flutter/widgets.dart';
import 'package:hetu_spotube_plugin/webview/webview_page.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Webview {
  final String uri;
  final FutureOr Function(Widget route) onNavigatorPush;
  final FutureOr<void> Function() onNavigatorPop;

  Webview({
    required this.onNavigatorPush,
    required this.onNavigatorPop,
    required this.uri,
  }) : _onUrlRequestStreamController = StreamController<String>.broadcast();

  StreamController<String>? _onUrlRequestStreamController;
  Stream<String> get onUrlRequestStream =>
      _onUrlRequestStreamController!.stream;

  webview_window.Webview? _webview;
  Future<void> open() async {
    if (Platform.isLinux) {
      final applicationSupportDir = await getApplicationSupportDirectory();
      final userDataFolder = Directory(
        join(applicationSupportDir.path, "webview_window_Webview2"),
      );

      if (!await userDataFolder.exists()) {
        await userDataFolder.create();
      }

      _webview = await WebviewWindow.create(
        configuration: CreateConfiguration(
          title: "Spotube Login",
          windowHeight: 720,
          windowWidth: 1280,
          userDataFolderWindows: userDataFolder.path,
        ),
      );
      _webview!.setOnUrlRequestCallback((url) {
        _onUrlRequestStreamController?.add(url);
        return true;
      });
      _webview!.launch(uri);

      return;
    }

    final route = WebviewPage(
      uri: uri,
      onLoad: (url) {
        _onUrlRequestStreamController?.add(url.toString());
      },
    );
    await onNavigatorPush(route);
  }

  Future<void> close() async {
    _onUrlRequestStreamController?.close();
    _onUrlRequestStreamController = null;
    if (Platform.isLinux) {
      _webview?.close();
      _webview = null;
      return;
    }
    await onNavigatorPop();
  }

  Future<List<Cookie>> getCookies(String url) async {
    if (Platform.isLinux) {
      final cookies = await _webview?.getAllCookies() ?? [];

      return cookies.map((cookie) {
        return Cookie(
          name: cookie.name,
          value: cookie.value,
          domain: cookie.domain,
          expiresDate: cookie.expires?.millisecondsSinceEpoch,
          isHttpOnly: cookie.httpOnly,
          isSecure: cookie.secure,
          isSessionOnly: cookie.sessionOnly,
          path: cookie.path,
        );
      }).toList();
    }

    return await CookieManager.instance(
      // Created in [WebviewPage]. Custom WebViewEnvironment for Windows otherwise it installs 
      // in installation directory so permission exception occurs.
      webViewEnvironment: await webViewEnvironment,
    ).getCookies(url: WebUri(url));
  }
}
