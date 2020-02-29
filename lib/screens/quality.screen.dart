import 'package:flutter/material.dart';
import 'package:metube/services/download.service.dart';
import 'package:metube/utils/service_locator.dart';

class QualityScreen extends StatefulWidget {
  final bool isVideo;
  final List streams;

  const QualityScreen({Key key, this.isVideo = false, this.streams})
      : super(key: key);
  @override
  _QualityScreenState createState() => _QualityScreenState();
}

class _QualityScreenState extends State<QualityScreen> {
  DownloadService _ds = locator.get<DownloadService>();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: (BuildContext ctx, int idx) => Card(
              child: widget.isVideo
                  ? ListTile(
                      leading: Icon(Icons.video_library),
                      title: Text(widget.streams[idx].container.toString()),
                      subtitle: Text(
                          '${widget.streams[idx].videoQualityLabel} - ${widget.streams[idx].size}'),
                      onTap: () async {
                        _ds.download(widget.streams[idx].url);
                      },
                    )
                  : ListTile(
                      leading: Icon(Icons.audiotrack),
                      title: Text(widget.streams[idx].container.toString()),
                      subtitle: Text(
                          '${widget.streams[idx].bitrate} - ${widget.streams[idx].size}'),
                      onTap: () async {
                        _ds.download(widget.streams[idx].url);
                      },
                    ),
            ));
  }
}
