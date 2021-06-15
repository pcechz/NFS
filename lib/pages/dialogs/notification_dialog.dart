import 'dart:convert';

import 'package:app/models/Advert.dart';
import 'package:app/models/Anchors.dart';
import 'package:app/routers/routes.dart';
import 'package:app/services/webservice.dart';
import 'package:app/ui/screens/home/widgets/CommentsPage.dart';
// import 'package:esv_api/esv_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_tags/flutter_tags.dart';
// import 'package:meet_network_image/meet_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NotificationDialog extends StatefulWidget {
  final String uuid;
  final String type;

  NotificationDialog({Key key, this.uuid, this.type}) : super(key: key);
  @override
  NotificationDialogState createState() => new NotificationDialogState();
}

class NotificationDialogState extends State<NotificationDialog> {
  List<Anchors> _anchors = List<Anchors>();

  List<String> selectedTags = [];

  @override
  void initState() {
    super.initState();
    // print("theverse+${widget.lesson.verses}");
    // if (widget.lesson.verses != null) {
    //   selectedTags = widget.lesson.verses.split(",");
    // }
    _populateAnchors(widget.type, widget.uuid);
  }

  Future<void> _populateAnchors(String type, String uuid) async {
    var url = "";
    type == "1" ? url = "https://nifes.org.ng/api/mobile/anchor/showid/$uuid" : url = "https://nifes.org.ng/api/mobile/bulletin/showid/$uuid";

    final http.Response response = await http.get(Uri.parse(url));
    final Map<String, dynamic> responseData = json.decode(response.body);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (token != null) {
      print("heeeee1");
      responseData[type == "1" ? 'anchors' : 'bulletins'].forEach((newsDetail) {
        final Anchors news = Anchors(description: newsDetail['description'], verses: newsDetail['verses'], uuid: newsDetail['uuid'], createdAt: newsDetail['created_at'], year: Year.fromJson(newsDetail['year']), month: Year.fromJson(newsDetail['month']), day: Year.fromJson(newsDetail['day']));

        // if (mounted)
        setState(() {
          _anchors.add(news);
          // _isLoading = false;
          if (_anchors.length > 0) {
            print("heeeee");
            selectedTags = _anchors[0].verses.length > 0 ? _anchors[0].verses.split(",") : null;
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => ParallaxPage(
            //             lesson: _anchors[0], type: type == "1" ? 1 : 2)));

          }
        });
      });
    }
  }

  _generateTags() {
    return selectedTags.isEmpty || selectedTags == null
        ? Container()
        : Container(
            padding: EdgeInsets.all(20),
            height: 200,
            alignment: Alignment.topLeft,
            child: Tags(
              alignment: WrapAlignment.center,
              itemCount: selectedTags.length,
              itemBuilder: (index) {
                return ItemTags(
                  index: index,
                  title: selectedTags[index],
                  color: Colors.blue,
                  activeColor: Colors.red,
                  onPressed: (Item item) async {
                    print('pressed');
                    // var esvApi =
                    //     ESVAPI('4cd7d044d7310d15b6ca4a233c1f44ed5a6de17e');

                    // var response = await esvApi.getPassageText(
                    //     selectedTags[index],
                    //     include_short_copyright: false,
                    //     include_copyright: false);

                    // print(response.passages.first);
                    // _showTestDialog(
                    //     response.passages.first, response.canonical);
                  },
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  elevation: 0.0,
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
//                textColor: ,
                  textColor: Colors.white,
                  textActiveColor: Colors.white,

                  textOverflow: TextOverflow.ellipsis,
                );
              },
            ),
          );
  }

  void _showTestDialog(String bible, String verse) {
    showDialog(
        context: context,
        barrierDismissible: false,
        //context: _scaffoldKey.currentContext,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(left: 25, right: 25),
            title: Center(child: Text(verse)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Container(
              height: 200,
              width: 300,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text(bible),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: RaisedButton(
                      child: new Text(
                        'close',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Color(0xFF121A21),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      onPressed: () {
                        //saveIssue();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                ],
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(Icons.close),
          onTap: () {
            //   Navigator.of(context).pop();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Rout.home));
          },
        ),
        title: Text(_anchors.length > 0 ? "${_anchors[0].day.name}/${_anchors[0].month.name}/${_anchors[0].year.name}" : ""),
        centerTitle: true,
        actions: <Widget>[
          if (widget.type == "1")
            IconButton(
              icon: Icon(
                Icons.comment,
                color: Colors.white,
              ),
              onPressed: () {
                // do something
                _anchors.length > 0 ? Navigator.push(context, MaterialPageRoute(builder: (context) => CommentsPage(_anchors[0].uuid))) : print("");
              },
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Bible Verses",
        onPressed: () {
          // Add your onPressed code here!

          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return _generateTags();
              });
        },
        child: Icon(Icons.library_books),
        backgroundColor: Colors.blue[900],
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
            child: _anchors.length > 0
                ? Html(
                    data: _anchors[0].description,
                    // onLinkTap: (url) {
                    //   var uri = Uri.dataFromString(url);
                    //   var uuid = uri.pathSegments[4];
                    //   print(uuid);
                    //   print("Opening $url...");
                    // },
                    // onImageTap: (src) {
                    //   print(src);
                    // },
                    onImageError: (exception, stackTrace) {
                      print(exception);
                    },
                  )
                : CircularProgressIndicator()),
      ),
    );
  }
}
