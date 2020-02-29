import 'package:metube/utils/service_locator.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_extractor/youtube_extractor.dart';

class YTService {
  YoutubeAPI ytApi = locator.get<YoutubeAPI>();
  YouTubeExtractor ytExtractor = locator.get<YouTubeExtractor>();

  Future<List<YT_API>> search(String query) async {
    return await ytApi.search(query);
  }

  Future<List> getAudioStream(String id) async {
    var streamInfo = await ytExtractor.getMediaStreamsAsync(id);
    // streamInfo.muxed[0].
    return streamInfo.audio;
  }

  Future<List> getVideoStream(String id) async {
    var streamInfo = await ytExtractor.getMediaStreamsAsync(id);
    return streamInfo.muxed;
  }
}
