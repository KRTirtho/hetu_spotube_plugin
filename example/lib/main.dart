import 'dart:async';

import 'package:example/localstorage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hetu_script/hetu_script.dart';
import 'package:hetu_spotube_plugin/hetu_spotube_plugin.dart';
import 'package:hetu_std/hetu_std.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final hetu = Hetu();
  getIt.registerSingleton<Hetu>(hetu);
  getIt.registerSingleton<SharedPreferences>(
    await SharedPreferences.getInstance(),
  );

  hetu.init();
  HetuStdLoader.loadBindings(hetu);
  await HetuStdLoader.loadBytecodeFlutter(hetu);
  await HetuSpotubePluginLoader.loadBytecodeFlutter(hetu);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyHome());
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    final hetu = getIt.get<Hetu>();
    BuildContext? pageContext;
    HetuSpotubePluginLoader.loadBindings(
      hetu,
      localStorageImpl: SharedPreferencesLocalStorage(
        getIt.get<SharedPreferences>(),
      ),
      onNavigatorPush: (route) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              pageContext = context;
              return Scaffold(
                appBar: AppBar(title: const Text("Webview Example")),
                body: route,
              );
            },
          ),
        );
      },
      onNavigatorPop: () {
        if (pageContext == null) return;
        Navigator.of(pageContext!).pop();
      },
    );

    _subscription = hetu.eval(r"""
      import 'module:std' as std
      import 'module:spotube_plugin' as spotube

      final { Stream } = std
      final { Webview, Cookie, LocalStorage } = spotube

      LocalStorage.setBool("test", true).then((_) {
        print("LocalStorage set test: true")

        LocalStorage.getBool("test").then((value) {
          print("LocalStorage get test: ${value}")
        })
      })
      

      final webview = Webview(
        uri: "https://google.com",
      )
      print("Webview created: ${webview.onUrlRequestStream}")
      webview.onUrlRequestStream.listen((url) {
        print("Webview URL request: ${url}")
        webview.getAllCookies().then((cookies) {
          print("Webview cookies: ${cookies}")
        })
      })
    """);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            FilledButton(
              onPressed: () async {
                final hetu = getIt.get<Hetu>();

                await hetu.eval("webview.open()");
              },
              child: Text("Open webview"),
            ),
          ],
        ),
      ),
    );
  }
}
