// ambient variable to access the service locator
import 'package:get_it/get_it.dart';
import 'package:metube/services/download.service.dart';
import 'package:metube/services/yt.service.dart';
import 'package:metube/utils/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_extractor/youtube_extractor.dart';

GetIt locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton(
    () => YTService(),
  );
  locator.registerLazySingleton(
    () => YoutubeAPI(
      kAPIKey,
      type: 'video',
    ),
  );
  locator.registerLazySingleton(
    () => YouTubeExtractor(),
  );
  locator.registerLazySingleton(
    () => PermissionHandler(),
  );
  locator.registerLazySingleton(
    () => DownloadService(),
  );
}
