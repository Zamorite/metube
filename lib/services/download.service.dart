import 'dart:async';
import 'dart:io';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:metube/utils/service_locator.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadService {
  PermissionHandler _ph = locator.get<PermissionHandler>();
  String downloadDirectory;

  Future<DownStat> download(String url, String fileName,
      {bool retry = false}) async {
    PermissionStatus permitted =
        await _ph.checkPermissionStatus(PermissionGroup.storage);

    switch (permitted) {
      case PermissionStatus.granted:
        return continueDownload(url, fileName);
        break;
      case PermissionStatus.neverAskAgain:
        return DownStat(false, 'Storage permission denied.');
      default:
        if (retry) {
          return DownStat(false, 'Storage permission denied.');
        } else {
          await _ph.requestPermissions([PermissionGroup.storage]);
          return download(url, fileName, retry: true);
        }
    }
  }

  Future<DownStat> continueDownload(
    String url,
    String fileName,
  ) async {
    if (url == null) {
      return DownStat(false, 'Requested video seems to have been encrypted.');
    }

    String downloadPath =
        (await DownloadsPathProvider.downloadsDirectory).path +
            Platform.pathSeparator +
            'YouTunes';

    // (await getExternalStorageDirectory()).create();

    // String downloadPath = (await getExternalStorageDirectory()).path +
    //     Platform.pathSeparator +
    //     'YouTunes';

    final downloadDirectory = Directory(downloadPath);
    bool hasExisted = await downloadDirectory.exists();
    if (!hasExisted) {
      downloadDirectory.create();
    }

    try {
      await FlutterDownloader.enqueue(
        url: url,
        fileName: fileName,
        savedDir: downloadPath, // + Platform.pathSeparator + fileName,
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      );

      return DownStat(true, 'Download Started successfully.');
    } catch (e) {
      print(e);
      return DownStat(false, 'Download failed for some reason.');
    }
  }
}

class DownStat {
  final bool success;
  final String message;

  DownStat(this.success, this.message);
}
