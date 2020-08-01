import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:metube/services/download.service.dart';
import 'package:metube/utils/constants.dart';
import 'package:metube/utils/service_locator.dart';

class QualityScreen extends StatefulWidget {
  final bool isVideo;
  final String name;
  final List streams;

  const QualityScreen({
    Key key,
    this.isVideo = false,
    this.streams,
    this.name,
  }) : super(key: key);
  @override
  _QualityScreenState createState() => _QualityScreenState();
}

class _QualityScreenState extends State<QualityScreen> {
  DownloadService _ds = locator.get<DownloadService>();

  List<bool> downloading = [];

  String getQuality(int bitrate) {
    double kbit = bitrate / 1024;
    return kbit < 128
        ? 'low'
        : kbit < 160
            ? 'medium'
            : kbit < 192 ? 'good' : kbit < 256 ? 'great' : 'best';
  }

  @override
  void initState() {
    super.initState();
    for (var stream in widget.streams) {
      downloading.add(false);
    }
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
      body: Builder(
        builder: (BuildContext context) => Column(
          children: <Widget>[
            Container(
              padding: kMd,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Select File Type',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Container(
                  padding: kTmd,
                  child: Text(
                    'Click on the download icon next to the file format you wish to save.',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: widget.streams.length,
                itemBuilder: (BuildContext ctx, int idx) => Card(
                  child: ListTile(
                    leading: Icon(LineIcons.file_audio_o),
                    title: Text(
                      widget.streams[idx].container
                          .toString()
                          .split('.')[1]
                          .toUpperCase(),
                    ),
                    trailing: downloading[idx]
                        ? Icon(LineIcons.hourglass_half)
                        : GestureDetector(
                            child: Icon(LineIcons.download),
                            onTap: () async {
                              setState(() {
                                downloading[idx] = true;
                              });

                              DownStat ds = await _ds.download(
                                widget.streams[idx].url,
                                widget.streams[idx].container
                                    .toString()
                                    .toLowerCase()
                                    .replaceAll('container', widget.name),
                              );

                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: ds.success ? kInfo : kWarn,
                                  content: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          padding: kXs,
                                          child: Text(
                                            ds.message,
                                            // style: TextStyle(
                                            //   color: kWhite
                                            // ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Icon(
                                          ds.success
                                              ? LineIcons.download
                                              : LineIcons.warning,
                                        ),
                                        padding: kXs,
                                      ),
                                    ],
                                  ),
                                ),
                              );

                              setState(() {
                                downloading[idx] = false;
                              });
                            },
                          ),
                    subtitle: Container(
                      padding: kVxs,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: kRmd,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  padding: kRxs,
                                  child: Icon(
                                    LineIcons.star,
                                    size: 12,
                                  ),
                                ),
                                Text(
                                  getQuality(widget.streams[idx].bitrate)
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: kRmd,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  padding: kRxs,
                                  child: Icon(
                                    LineIcons.save,
                                    size: 12,
                                  ),
                                ),
                                Text(
                                  '${(widget.streams[idx].size / (1024 * 1024)).toStringAsFixed(2)}MB',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
