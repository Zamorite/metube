import 'package:flutter/material.dart';
import 'package:metube/screens/video.screen.dart';
import 'package:youtube_api/youtube_api.dart';

class ListScreen extends StatefulWidget {
  final List vidList;
  final String query;

  const ListScreen({Key key, this.vidList, this.query}) : super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
//   static String key = 'YOUR_API_KEY';
// YoutubeAPI ytApi = new YoutubeAPI(key);
// List<YT_API> vidList = [];

// String query = "Flutter";
// vidList = await ytApi.Search(query);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Videos for: \'${widget.query}\''),
        // centerTitle: true,
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: widget.vidList.length,
        itemBuilder: (ctx, idx) => ListTile(
          title: Text(
            widget.vidList[idx].title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          leading: Image.network(
            widget.vidList[idx].thumbnail['default']['url'],
          ),
          subtitle: Text(widget.vidList[idx].channelTitle),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => VidScreen(
                video: widget.vidList[idx],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
