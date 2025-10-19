import 'package:hetu_script/binding.dart';
import 'package:hetu_script/hetu_script.dart';
import 'package:hetu_spotube_plugin/youtube_engine/youtube_engine.dart';

extension YoutubeEngineBinding on YouTubeEngine {
  dynamic htFetch(String id) {
    return switch (id) {
      "search" => (
        HTEntity entity, {
        List<dynamic> positionalArgs = const [],
        Map<String, dynamic> namedArgs = const {},
        List<HTType> typeArgs = const [],
      }) {
        return search(positionalArgs[0]);
      },
      "getVideo" => (
        HTEntity entity, {
        List<dynamic> positionalArgs = const [],
        Map<String, dynamic> namedArgs = const {},
        List<HTType> typeArgs = const [],
      }) {
        return getVideo(positionalArgs[0]);
      },
      "streamManifest" => (
        HTEntity entity, {
        List<dynamic> positionalArgs = const [],
        Map<String, dynamic> namedArgs = const {},
        List<HTType> typeArgs = const [],
      }) {
        return streamManifest(positionalArgs[0]);
      },
      _ => throw HTError.undefined(id),
    };
  }
}

class YouTubeEngineClassBinding extends HTExternalClass {
  final YouTubeEngine Function() createYoutubeEngine;

  YouTubeEngineClassBinding({required this.createYoutubeEngine})
    : super("YouTubeEngine");

  @override
  dynamic memberGet(String varName, {String? from}) {
    return switch (varName) {
      "YouTubeEngine" =>
        (
          HTEntity entity, {
          List<dynamic> positionalArgs = const [],
          Map<String, dynamic> namedArgs = const {},
          List<HTType> typeArgs = const [],
        }) {
          final engine = createYoutubeEngine();
          return YouTubeEngine(
            search: engine.search,
            getVideo: engine.getVideo,
            streamManifest: engine.streamManifest,
          );
        },
      _ => HTError.undefined(varName),
    };
  }

  @override
  instanceMemberGet(object, String varName) =>
      (object as YouTubeEngine).htFetch(varName);
}
