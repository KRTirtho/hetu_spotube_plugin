import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

final webViewEnvironment =
    Platform.isWindows
        ? getApplicationSupportDirectory().then((directory) async {
          return await WebViewEnvironment.create(
            settings: WebViewEnvironmentSettings(
              userDataFolder: join(directory.path, 'inappwebview_data'),
            ),
          );
        })
        : Future.value(null);

class WebviewPage extends StatelessWidget {
  final String uri;
  final void Function(String url)? onLoad;
  const WebviewPage({super.key, required this.uri, this.onLoad});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: webViewEnvironment,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(uri)),
          webViewEnvironment: snapshot.data,
          onLoadStop: (controller, url) {
            try {
              if (onLoad != null && url != null) {
                onLoad!(url.toString());
              }
            } catch (e, stack) {
              debugPrint("[Webview][onLoad] Error: $e");
              debugPrintStack(stackTrace: stack);
              rethrow;
            }
          },
        );
      },
    );
  }
}
