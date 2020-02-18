import 'package:flutter/material.dart';
import 'package:metube/screens/video.screen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                    padding: EdgeInsets.only(bottom: 20),
                  ),
                  MaterialButton(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => VidScreen(),
                        ),
                      );
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
