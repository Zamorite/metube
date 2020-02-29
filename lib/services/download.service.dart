import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class DownloadService {
  DownloadService() {
    initDownloader();
  }

  initDownloader() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterDownloader.initialize();
  }

  download(String url) async {
    return await FlutterDownloader.enqueue(
      url: url,
      savedDir: 'downloadPath',
      showNotification: true,
      openFileFromNotification: true,
    );
  }
}
