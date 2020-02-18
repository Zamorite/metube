import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VidScreen extends StatefulWidget {
  @override
  _VidScreenState createState() => _VidScreenState();
}

class _VidScreenState extends State<VidScreen> {
  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'iLnmTe5Q2Qw',
    flags: YoutubePlayerFlags(
      autoPlay: true,
      mute: true,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'MeTube',
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                // progressIndicatorColor: Colors.amber,
                // progressColors: ProgressBarColors(
                //     playedColor: Colors.amber,
                //     handleColor: Colors.amberAccent,
                // ),
                // onReady: () {
                //     // _controller.addListener(listener);
                // },
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 15,
                ),
                title: Text(
                  'This is the Spooky Video Title !',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'Channel Name',
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
                  'Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero\'s De Finibus Bonorum et Malorum for use in a type specimen book.',
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
                      onPressed: () {},
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
                      onPressed: () {},
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
