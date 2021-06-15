import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app/models/Anchors.dart';
import 'package:html/parser.dart';
import 'package:app/pages/details/detail_page.dart';
import 'package:app/pages/details/parallax_page.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class AnchorsPage extends StatefulWidget {
  AnchorsPage({Key key, this.title, this.type}) : super(key: key);

  final String title;
  final int type;

  @override
  _AnchorsPageState createState() => _AnchorsPageState();
}

class _AnchorsPageState extends State<AnchorsPage> {
  // List lessons;
  List<Anchors> _anchors = List<Anchors>();
  var _isLoading = true, _isInit = false;
  @override
  void initState() {
    super.initState();
    if (!_isInit) {
      _populateAnchors();
    }
    _isInit = true;
  }

  Future<void> _populateAnchors() async {
    final http.Response response =
        await http.get("https://nifes.org.ng/api/mobile/bulletin/index");
    final Map<String, dynamic> responseData = json.decode(response.body);

    responseData['bulletins'].forEach((newsDetail) {
      final Anchors news = Anchors(
          description: newsDetail['description'],
          verses: newsDetail['verses'],
          uuid: newsDetail['uuid'],
          createdAt: newsDetail['created_at'],
          year: Year.fromJson(newsDetail['year']),
          month: Year.fromJson(newsDetail['month']),
          day: Year.fromJson(newsDetail['day']));
      setState(() {
        _anchors.add(news);
        _isLoading = false;
      });
    });
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  @override
  Widget build(BuildContext context) {
    ListTile makeListTile(Anchors lesson) => ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.white24))),
            child:
                Icon(Icons.book_online, color: Color.fromRGBO(58, 66, 86, 1.0)),
          ),

          title: Text(
            "${lesson.day.name}/${lesson.month.name}/${lesson.year.name}",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

          subtitle: Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                      // tag: 'hero',
                      )),
            ],
          ),
          trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ParallaxPage(lesson: lesson, type: 2)));
          },
        );

    Card makeCard(Anchors lesson) => Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, //Color.fromRGBO(64, 75, 96, .9),
                border: Border.all(color: Color.fromRGBO(58, 66, 86, 1.0))),
            child: makeListTile(lesson),
          ),
        );

    final makeBody = Container(
      // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
      child: _isLoading
          ? SkeletonLoader(
              builder: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: 10,
                            color: Colors.white,
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            height: 12,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              items: 5,
              period: Duration(seconds: 2),
              highlightColor: Colors.lightBlue[300],
              direction: SkeletonDirection.ltr,
            )
          : ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _anchors.length,
              itemBuilder: (BuildContext context, int index) {
                return makeCard(_anchors[index]);
              },
            ),
    );

    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: Colors.lightBlue[300], //Color.fromRGBO(58, 66, 86, 1.0),
      title: Text("Bulletins"),
      // actions: <Widget>[
      //   IconButton(
      //     icon: Icon(Icons.calendar_today, color: Colors.white),
      //     onPressed: () {},
      //   )
      // ],
    );

    return Scaffold(
        backgroundColor: Colors.white, //Color.fromRGBO(58, 66, 86, 1.0),
        appBar: topAppBar,
        body: makeBody);
  }
}
