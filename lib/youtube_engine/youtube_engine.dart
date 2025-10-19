class YouTubeEngine {
  final Future<List<Map<String, dynamic>>> Function(String query) search;
  final Future<Map<String, dynamic>> Function(String videoId) getVideo;
  final Future<List<Map<String, dynamic>>> Function(String videoId)
  streamManifest;

  YouTubeEngine({
    required this.search,
    required this.getVideo,
    required this.streamManifest,
  });
}
