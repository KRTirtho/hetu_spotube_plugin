import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hetu_script/hetu/hetu.dart';
import 'package:hetu_spotube_plugin/webview/webview.binding.dart';

class HetuSpotubePluginLoader {
  static void loadBindings(
    Hetu hetu, {
    required FutureOr Function(Widget route) onNavigatorPush,
    required FutureOr<void> Function() onNavigatorPop,
  }) {
    final classes = [
      CookieClassBinding(),
      WebviewClassBinding(
        onNavigatorPush: onNavigatorPush,
        onNavigatorPop: onNavigatorPop,
      ),
    ];

    for (final classBinding in classes) {
      hetu.interpreter.bindExternalClass(classBinding);
    }
  }

  static Future<void> loadBytecodeFlutter(Hetu hetu) async {
    final byteCodeFile = await rootBundle.load(
      'packages/hetu_spotube_plugin/assets/bytecode/spotube_plugin.out',
    );
    final byteCode = byteCodeFile.buffer.asUint8List();

    hetu.loadBytecode(bytes: byteCode, moduleName: 'spotube_plugin');
  }
}
