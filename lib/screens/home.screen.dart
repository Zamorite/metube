import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:metube/screens/list.screen.dart';
import 'package:metube/screens/video.screen.dart';
import 'package:metube/services/yt.service.dart';
import 'package:metube/utils/constants.dart';
import 'package:metube/utils/service_locator.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:youtube_api/youtube_api.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String query;
  YTService _yts = locator.get<YTService>();
  TextEditingController _ctrl = TextEditingController();
  bool searching = false;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: 'logo',
          child: Image.asset(
            kLogo,
            width: width * .20,
            // fit: BoxFit.fitWidth,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        padding: kSm,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  padding: kMd,
                  decoration: BoxDecoration(
                    color: kBlack,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(LineIcons.music),
                      ),
                      Expanded(
                        child: Container(
                          padding: kLmd,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'YouTunes',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Download audio off YouTube videos.\nFor educational* purposes only.',
                                // maxLines: 2,
                                style: TextStyle(
                                  color: Colors.white,
                                  // fontSize: 24,
                                  // fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: kTsm,
                  child: Container(
                    padding: kMd,
                    decoration: BoxDecoration(
                      color: kInfo,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            // padding: kLxs,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Alert',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'This project depends on ads for monitization. Hence, you would be presented with them, in a nice way though.',
                                  // maxLines: 2,
                                  style: TextStyle(
                                    color: Colors.white,
                                    // fontSize: 24,
                                    // fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: kLmd,
                          child: Icon(
                            LineIcons.warning,
                            size: 40,
                            // color: Colors.blue,
                            color: Color(0xFF397A8F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
                          child: Icon(
                            LineIcons.hourglass_half,
                          ),
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
