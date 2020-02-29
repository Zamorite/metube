import 'package:flutter/material.dart';
import 'package:metube/screens/list.screen.dart';
import 'package:metube/screens/video.screen.dart';
import 'package:metube/services/yt.service.dart';
import 'package:metube/utils/service_locator.dart';
import 'package:youtube_api/youtube_api.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String query;
  YTService _yts = locator.get<YTService>();
  TextEditingController _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MeTube',
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Text(
                'Welcome to MeTube !',
                style: TextStyle(
                  fontSize: 24,
                  height: 2,
                  wordSpacing: 3,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Enter a Youtube link or a search keyword below to get started...',
                      style:
                          TextStyle(fontSize: 20, height: 1.5, wordSpacing: 2),
                    ),
                  ),
                  Container(
                    child: TextField(
                      controller: _ctrl,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      keyboardType: TextInputType.url,
                      onChanged: (q) => query = q,
                      onSubmitted: (q) async {
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
                      },
                    ),
                    padding: EdgeInsets.only(bottom: 20),
                  ),
                  MaterialButton(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    color: Colors.blue,
                    onPressed: () async {
                      if (![null, ''].contains(query)) {
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
                      }
                    },
                    child: Text(
                      'SEARCH',
                      style: TextStyle(
                        fontSize: 24,
                        letterSpacing: 3,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
