import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebviewPage extends StatelessWidget {
  final String uri;
  final void Function(String url)? onLoad;
  const WebviewPage({super.key, required this.uri, this.onLoad});

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(uri)),
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
  }
}
