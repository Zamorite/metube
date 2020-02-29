import 'package:flutter/material.dart';
import 'package:metube/screens/quality.screen.dart';
import 'package:metube/services/yt.service.dart';
import 'package:metube/utils/service_locator.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VidScreen extends StatefulWidget {
  final YT_API video;

  const VidScreen({Key key, this.video}) : super(key: key);

  @override
  _VidScreenState createState() => _VidScreenState();
}

class _VidScreenState extends State<VidScreen> {
  YoutubePlayerController _ctrl;
  YTService _yts = locator.get<YTService>();

  @override
  void initState() {
    super.initState();

    _ctrl = YoutubePlayerController(
      initialVideoId: widget.video.id,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        // mute: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MeTube',
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              YoutubePlayer(
                controller: _ctrl,
                showVideoProgressIndicator: true,
                // progressIndicatorColor: Colors.amber,
                // progressColors: ProgressBarColors(
                //     playedColor: Colors.amber,
                //     handleColor: Colors.amberAccent,
                // ),
                // onReady: () {
                //     // _ctrl.addListener(listener);
                // },
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 15,
                ),
                title: Text(
                  widget.video.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    widget.video.channelTitle,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 15,
                ),
                child: Text(
                  widget.video.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 25,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    MaterialButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      onPressed: () async {
                        List streams =
                            await _yts.getAudioStream(widget.video.id);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => QualityScreen(
                              streams: streams,
                            ),
                          ),
                        );
                      },
                      child: Text('Audio'),
                    ),
                    Flexible(
                      child: Text(
                        'Download',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    MaterialButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      onPressed: () async {
                        List streams =
                            await _yts.getVideoStream(widget.video.id);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => QualityScreen(
                              streams: streams,
                              isVideo: true,
                            ),
                          ),
                        );
                      },
                      child: Text('Video'),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
