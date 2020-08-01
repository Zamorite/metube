import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:metube/screens/quality.screen.dart';
import 'package:metube/services/yt.service.dart';
import 'package:metube/utils/constants.dart';
import 'package:metube/utils/service_locator.dart';
import 'package:progress_indicators/progress_indicators.dart';
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
  bool playerReady = false, loading = false;
  bool paused = true;
  // Duration played = Duration();

  @override
  void initState() {
    super.initState();

    _ctrl = YoutubePlayerController(
      initialVideoId: widget.video.id,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        hideControls: true,
        // forceHideAnnotation: true,

        // mute: true,
      ),
    )..addListener(listener);
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _ctrl.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'YouTunes',
          style: TextStyle(color: Colors.black),
        ),
        leading: Hero(
          tag: 'logo',
          child: Image.asset(
            kLogo,
            width: width * .20,
            // fit: BoxFit.fitWidth,
          ),
        ),
        backgroundColor: Colors.white,
        // centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: kMd,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    widget.video.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Container(
                    padding: kTmd,
                    child: Text(
                      widget.video.channelTitle,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              Hero(
                tag: widget.video.id,
                child: YoutubePlayer(
                  controller: _ctrl,
                  onReady: () {
                    setState(() {
                      playerReady = true;
                    });
                  },
                  onEnded: (YoutubeMetaData meta) {
                    setState(() {
                      paused = true;
                    });
                  },
                ),
              ),
              ProgressBar(
                controller: _ctrl,
                colors: ProgressBarColors(
                  backgroundColor: Colors.grey,
                  playedColor: Colors.blue,
                  handleColor: Colors.transparent,
                ),
              ),
              Container(
                padding: kMd,
                child: Text(
                  widget.video.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          Container(
            padding: kSm,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                child: Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: playerReady,
                  child: ListTile(
                    leading: GestureDetector(
                      child: Icon(LineIcons.stop),
                      onTap: () => _ctrl.seekTo(_ctrl.metadata.duration),
                    ),
                    title: Offstage(),
                    trailing: loading
                        ? GlowingProgressIndicator(
                            child: Icon(LineIcons.hourglass_half),
                          )
                        : GestureDetector(
                            child: Hero(
                                tag: 'dl_icon',
                                child: Icon(LineIcons.download)),
                            onTap: () async {
                              setState(() {
                                loading = true;
                              });

                              if (!paused) {
                                _ctrl.pause();
                                paused = true;
                              }

                              List streams =
                                  await _yts.getAudioStream(widget.video.id);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => QualityScreen(
                                    name: widget.video.title,
                                    streams: streams,
                                  ),
                                ),
                              );

                              setState(() {
                                loading = false;
                              });
                            },
                          ),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius:
                            5.0, // has the effect of softening the shadow
                        spreadRadius:
                            0.0, // has the effect of extending the shadow
                        offset: Offset(
                          0.0, // horizontal, move right 10
                          1.0, // vertical, move down 10
                        ),
                      )
                    ]),
              ),
            ),
          ),
          Container(
            padding: kMd,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: playerReady
                  ? Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: kXs,
                            child: GestureDetector(
                              child: Icon(LineIcons.fast_backward),
                              onTap: () => rev(),
                            ),
                          ),
                          Container(
                            padding: kXs,
                            child: GestureDetector(
                              child: Icon(playerReady
                                  ? (paused ? LineIcons.play : LineIcons.pause)
                                  : Icons.hourglass_empty),
                              onTap: playerReady
                                  ? () => setState(
                                        () {
                                          if (paused) {
                                            _ctrl.play();
                                          } else {
                                            _ctrl.pause();
                                          }
                                          paused = !paused;
                                        },
                                      )
                                  : null,
                            ),
                          ),
                          Container(
                            padding: kXs,
                            child: GestureDetector(
                              child: Icon(LineIcons.fast_forward),
                              onTap: () => ff(),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      padding: kXs,
                      child: GlowingProgressIndicator(
                        child: Icon(
                          LineIcons.hourglass_half,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void listener() {
    if (playerReady && mounted && !_ctrl.value.isFullScreen) {
      setState(() {});
    }
  }

  void ff() {
    Duration rem = _ctrl.metadata.duration - _ctrl.value.position;

    setState(() {
      if (rem.inSeconds > 5) {
        _ctrl.seekTo(
          _ctrl.value.position + Duration(seconds: 10),
        );
        paused = false;
      } else {
        _ctrl.seekTo(_ctrl.metadata.duration);
      }
    });
  }

  void rev() {
    Duration pos = _ctrl.value.position;

    setState(() {
      if (pos.inSeconds > 10) {
        _ctrl.seekTo(
          _ctrl.value.position - Duration(seconds: 10),
        );
        paused = false;
      } else {
        _ctrl.seekTo(Duration());
      }
    });
  }
}
