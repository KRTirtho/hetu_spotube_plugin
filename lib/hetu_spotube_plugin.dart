import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hetu_script/hetu/hetu.dart';
import 'package:hetu_spotube_plugin/localstorage/localstorage.binding.dart';
import 'package:hetu_spotube_plugin/localstorage/localstorage.dart';
import 'package:hetu_spotube_plugin/webview/webview.binding.dart';

export 'package:hetu_spotube_plugin/localstorage/localstorage.dart';

class HetuSpotubePluginLoader {
  static void loadBindings(
    Hetu hetu, {
    required Localstorage localStorageImpl,
    required FutureOr Function(Widget route) onNavigatorPush,
    required FutureOr<void> Function() onNavigatorPop,
  }) {
    final classes = [
      CookieClassBinding(),
      WebviewClassBinding(
        onNavigatorPush: onNavigatorPush,
        onNavigatorPop: onNavigatorPop,
      ),
      LocalStorageClassBinding(localStorageImpl: localStorageImpl),
    ];

    for (final classBinding in classes) {
      hetu.interpreter.bindExternalClass(classBinding);
    }
  }

  /// Loads the bytecode for the Spotube plugin from the Flutter asset bundle.
  /// Add following to your `pubspec.yaml`:
  ///
  /// ```yaml
  /// flutter:
  ///   assets:
  ///     - packages/hetu_spotube_plugin/assets/bytecode/spotube_plugin.out
  /// ```
  static Future<void> loadBytecodeFlutter(Hetu hetu) async {
    final byteCodeFile = await rootBundle.load(
      'packages/hetu_spotube_plugin/assets/bytecode/spotube_plugin.out',
    );
    final byteCode = byteCodeFile.buffer.asUint8List();

    hetu.loadBytecode(bytes: byteCode, moduleName: 'spotube_plugin');
  }
}
