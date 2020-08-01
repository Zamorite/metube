import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:metube/screens/video.screen.dart';
import 'package:metube/services/yt.service.dart';
import 'package:metube/utils/constants.dart';
import 'package:metube/utils/service_locator.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:youtube_api/youtube_api.dart';

class ListScreen extends StatefulWidget {
  final List vidList;
  final String query;

  ListScreen({Key key, this.vidList, this.query}) : super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  String query;
  YTService _yts = locator.get<YTService>();
  TextEditingController _ctrl;
  bool searching = false;

  @override
  void initState() {
    super.initState();
    query = widget.query;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    _ctrl = TextEditingController(text: query);

    return Scaffold(
      appBar: AppBar(
        leading: Hero(
          tag: 'logo',
          child: Image.asset(
            kLogo,
            width: width * .20,
            // fit: BoxFit.fitWidth,
          ),
        ),
        title: Text(
          'Videos for: \'$query\'',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,

        // centerTitle: true,
      ),
      body: Container(
        padding: kSm,
        child: Stack(
          children: <Widget>[
            ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: widget.vidList.length,
              itemBuilder: (ctx, idx) => ListTile(
                // isThreeLine: true,
                contentPadding: kXs,
                title: Text(
                  widget.vidList[idx].title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                leading: Hero(
                  tag: widget.vidList[idx].id,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: widget.vidList[idx].thumbnail['default']['url'],
                    ),
                  ),
                ),
                subtitle: Container(
                  child: Text(widget.vidList[idx].channelTitle),
                  padding: kTxs,
                ),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => VidScreen(
                      video: widget.vidList[idx],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                child: ListTile(
                  leading: Icon(LineIcons.youtube_play),
                  title: TextField(
                    controller: _ctrl,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    keyboardType: TextInputType.url,
                    onChanged: (q) => query = q,
                    onSubmitted: (q) async {
                      setState(() {
                        searching = true;
                      });

                      List<YT_API> vidList = await _yts.search(query);

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              (vidList.length > 1 || vidList.length == 0)
                                  ? ListScreen(
                                      vidList: vidList,
                                      query: query,
                                    )
                                  : VidScreen(
                                      video: vidList[0],
                                    ),
                        ),
                      );

                      setState(() {
                        searching = false;
                      });
                    },
                    decoration: InputDecoration.collapsed(hintText: 'Search'),
                    cursorColor: Colors.grey,
                  ),
                  trailing: searching
                      ? GlowingProgressIndicator(
                          child: Icon(LineIcons.hourglass_half),
                        )
                      : GestureDetector(
                          child: Icon(LineIcons.search),
                          onTap: () async {
                            if (![null, ''].contains(query)) {
                              setState(() {
                                searching = true;
                              });

                              List<YT_API> vidList = await _yts.search(query);

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => (vidList.length > 1 ||
                                          vidList.length == 0)
                                      ? ListScreen(
                                          vidList: vidList,
                                          query: query,
                                        )
                                      : VidScreen(
                                          video: vidList[0],
                                        ),
                                ),
                              );

                              setState(() {
                                searching = false;
                              });
                            }
                          },
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
                // height: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
