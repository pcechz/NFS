import 'dart:convert';

import 'package:app/model/BibleVerse.dart';
import 'package:app/pages/lists/anchors_page.dart';
import 'package:app/pages/lists/lists.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:http/http.dart' as http;
import 'package:app/model/lesson.dart';
import 'package:html/parser.dart';
import 'package:app/models/Anchors.dart';
import 'package:app/ui/screens/home/widgets/CommentsPage.dart';
import 'package:intl/intl.dart';
import 'parallax_component.dart';
// import 'package:fluttertagselector/fluttertagselector.dart';
// import 'package:esv_api/esv_api.dart';

class ParallaxPage extends StatefulWidget {
  Anchors lesson;
  final int type;
  ParallaxPage({Key key, this.lesson, this.type}) : super(key: key);
  @override
  _ParallaxPageState createState() => _ParallaxPageState();
}

class _ParallaxPageState extends State<ParallaxPage> {
  List<String> selectedTags = [];
  List<BibleVerse> _verses = List<BibleVerse>();

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2005, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
//         String format = new DateFormat('dd/MMMM/yyyy').format(picked);
// var formattedDate = format.parse(date)
        var newFormat = DateFormat("dd/MMMM/yyyy");
        String updatedDt = newFormat.format(picked);

        selectedDate = picked;
        print(updatedDt);
        if (widget.type == 1) {
          _populateAnchorss();
        } else {
          _populateBulletins();
        }
      });
  }

  Future<void> _populateBulletins() async {
    final http.Response response = await http
        .get(Uri.parse("https://nifes.org.ng/api/mobile/bulletin/index"));
    final Map<String, dynamic> responseData = json.decode(response.body);

    responseData['bulletins'].forEach((newsDetail) {
      var newFormat = DateFormat("d/MMMM/yyyy");
      String updatedDt = newFormat.format(selectedDate);
      String jsonyear = Year.fromJson(newsDetail['year']).name;
      String jsonmonth = Year.fromJson(newsDetail['month']).name;
      String jsonday = Year.fromJson(newsDetail['day']).name;
      String alldate = "${jsonday}/${jsonmonth}/${jsonyear}";
      if (updatedDt == alldate) {
        final Anchors anch = Anchors(
            description: newsDetail['description'],
            verses: newsDetail['verses'],
            uuid: newsDetail['uuid'],
            createdAt: newsDetail['created_at'],
            year: Year.fromJson(newsDetail['year']),
            month: Year.fromJson(newsDetail['month']),
            day: Year.fromJson(newsDetail['day']));
        setState(() {
          widget.lesson = anch;
          if (widget.lesson.verses != null) {
            selectedTags = widget.lesson.verses.split(",");
          }
        });
      }
    });
  }

  Future<void> _populateAnchorss() async {
    final http.Response response = await http
        .get(Uri.parse("https://nifes.org.ng/api/mobile/anchor/index"));
    final Map<String, dynamic> responseData = json.decode(response.body);

    responseData['anchors'].forEach((newsDetail) {
      var newFormat = DateFormat("d/MMMM/yyyy");
      String updatedDt = newFormat.format(selectedDate);
      String jsonyear = Year.fromJson(newsDetail['year']).name;
      String jsonmonth = Year.fromJson(newsDetail['month']).name;
      String jsonday = Year.fromJson(newsDetail['day']).name;
      String alldate = "${jsonday}/${jsonmonth}/${jsonyear}";
      if (updatedDt == alldate) {
        Anchors news = Anchors(
            description: newsDetail['description'],
            topic: newsDetail['topic'] ?? "",
            oneYear: newsDetail['one_year'] ?? "",
            bibleReading: newsDetail['bible_reading'] ?? "",
            wordOFToday: newsDetail['word_of_today'] ?? "",
            prayers: newsDetail['prayers'],
            verses: newsDetail['verses'],
            uuid: newsDetail['uuid'],
            createdAt: newsDetail['created_at'],
            year: Year.fromJson(newsDetail['year']),
            month: Year.fromJson(newsDetail['month']),
            day: Year.fromJson(newsDetail['day']));
        setState(() {
          widget.lesson = news;
          if (widget.lesson.verses != null) {
            selectedTags = widget.lesson.verses.split(",");
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    print("theverse+${widget.lesson.verses}");
    if (widget.lesson.verses != null) {
      selectedTags = widget.lesson.verses.split(",");
    }
  }

  Future<void> _populateAnchors(String pass) async {
    var finalpass = pass.replaceAll(" ", "");
    final http.Response response =
        await http.get(Uri.parse("https://bible-api.com/$finalpass"));
    final Map<String, dynamic> responseData = json.decode(response.body);

    responseData['verses'].forEach((newsDetail) {
      final BibleVerse news = BibleVerse(
          bookId: newsDetail['book_id'],
          bookName: newsDetail['book_name'],
          chapter: newsDetail['chapter'],
          verse: newsDetail['verse'],
          text: newsDetail['text']);
      setState(() {
        _verses.add(news);
      });
    });
    //_showTestDialog(bible: _);
    if (_verses.length > 0) {
      // print(_verses[0].);
      _showDialog(_verses, pass);
    }
  }

  _generateTags() {
    return selectedTags.isEmpty
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
                    _populateAnchors(selectedTags[index]);
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

  void _showDialog(List<BibleVerse> bible, String verse) {
    showDialog(
        context: context,
        barrierDismissible: false,
        //context: _scaffoldKey.currentContext,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(left: 25, right: 25),
            title: Center(child: Text(verse)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Container(
              height: 500,
              width: 300,
              child: SingleChildScrollView(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _verses.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                        child: Text(
                            '${_verses[index].verse}. ${_verses[index].text}'),
                        padding: EdgeInsets.all(2.0));
                  },
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

  List<Widget> makeWidgetChildren(List<BibleVerse> jsonObject) {
    ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: _verses.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
            child:
                Text('${jsonObject[index].verse}. ${jsonObject[index].text}'),
            padding: EdgeInsets.all(8.0));
      },
    );
  }

  Container makeBody() {
    return widget.type == 2
        ? Container(
            // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),

            child: SingleChildScrollView(
                child: Html(
            data: widget.lesson.description,
            //Optional parameters:
            // customImageRenders: {
            //   networkSourceMatcher(domains: ["flutter.dev"]):
            //       (context, attributes, element) {
            //     return FlutterLogo(size: 36);
            //   },
            //   networkSourceMatcher(domains: ["mydomain.com"]): networkImageRender(
            //     headers: {"Custom-Header": "some-value"},
            //     altWidget: (alt) => Text(alt),
            //     loadingWidget: () => Text("Loading..."),
            //   ),
            //   // On relative paths starting with /wiki, prefix with a base url
            //   (attr, _) => attr["src"] != null && attr["src"].startsWith("/wiki"):
            //       networkImageRender(
            //           mapUrl: (url) => "https://upload.wikimedia.org" + url),
            //   // Custom placeholder image for broken links
            //   networkSourceMatcher():
            //       networkImageRender(altWidget: (_) => FlutterLogo()),
            // },
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
          )))
        : Container(
            child: Stack(children: <Widget>[
            Container(
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Card(
                      color: Color.fromRGBO(204, 51, 102, 0.8),
                      elevation: 0,
                      margin: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        height: 150,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 5.0),
                            ),
                            Text("Topic",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white.withOpacity(0.8))),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AutoSizeText(
                                widget.lesson.topic != null
                                    ? _parseHtmlString(widget.lesson.topic)
                                    : "",
                                style: TextStyle(
                                    fontSize: 23,
                                    color: Colors.white.withOpacity(0.8)),
                                minFontSize: 8,
                                maxLines: 4,
                              ),
                            )
                          ],
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 10.0),
                  ),
                  Card(
                      color: Color.fromRGBO(0, 51, 102, 0.8),
                      elevation: 0,
                      margin: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        height: 60,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
                            ),
                            Text("Bible Reading",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white.withOpacity(0.5))),
                            AutoSizeText(
                              widget.lesson.bibleReading != null
                                  ? _parseHtmlString(widget.lesson.bibleReading)
                                  : "",
                              style:
                                  TextStyle(fontSize: 11, color: Colors.white),
                              minFontSize: 6,
                              maxLines: 3,
                            ),
                          ],
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 10.0),
                  ),
                  Card(
                      color: Color.fromRGBO(204, 51, 102, 0.8),
                      elevation: 0,
                      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(color: Colors.white, width: 0),
                              right: BorderSide(color: Colors.green, width: 0),
                              left: BorderSide(color: Colors.purple, width: 0)),
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 5.0),
                            ),
                            Text("Word Of Today",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),

                            AutoSizeText(
                              widget.lesson.wordOFToday != null
                                  ? _parseHtmlString(widget.lesson.wordOFToday)
                                  : "",
                              minFontSize: 12,
                              maxLines: 10,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic),
                            )
                            // Text(

                            //     widget.lesson.wordOFToday.length > 0
                            //         ? _parseHtmlString(
                            //             widget.lesson.wordOFToday)
                            //         : "",
                            //     style: TextStyle(
                            //         fontWeight: FontWeight.normal,

                            //         color: Colors.white,
                            //         fontStyle: FontStyle.italic)),
                            // //  Text(_verses.length > 0 ? _verses[0].urlToImage : " ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          ],
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 10.0),
                  ),
                  Html(
                    data: widget.lesson.description,
                    //Optional parameters:
                    // customImageRenders: {
                    //   networkSourceMatcher(domains: ["flutter.dev"]):
                    //       (context, attributes, element) {
                    //     return FlutterLogo(size: 36);
                    //   },
                    //   networkSourceMatcher(domains: ["mydomain.com"]): networkImageRender(
                    //     headers: {"Custom-Header": "some-value"},
                    //     altWidget: (alt) => Text(alt),
                    //     loadingWidget: () => Text("Loading..."),
                    //   ),
                    //   // On relative paths starting with /wiki, prefix with a base url
                    //   (attr, _) => attr["src"] != null && attr["src"].startsWith("/wiki"):
                    //       networkImageRender(
                    //           mapUrl: (url) => "https://upload.wikimedia.org" + url),
                    //   // Custom placeholder image for broken links
                    //   networkSourceMatcher():
                    //       networkImageRender(altWidget: (_) => FlutterLogo()),
                    // },
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
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 10.0),
                  ),
                  Card(
                      color: Color.fromRGBO(0, 0, 51, 0.8),
                      elevation: 0,
                      margin: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        height: 150,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 5.0),
                            ),
                            Text("Prayers",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white.withOpacity(0.8))),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AutoSizeText(
                                widget.lesson.prayers != null
                                    ? _parseHtmlString(widget.lesson.prayers)
                                    : "",
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white.withOpacity(0.8)),
                                minFontSize: 8,
                                maxLines: 8,
                              ),
                            )
                          ],
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 10.0),
                  ),
                  Card(
                      color: Color.fromRGBO(0, 51, 102, 0.8),
                      elevation: 0,
                      margin: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        height: 60,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
                            ),
                            Text("One Year Plan",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white.withOpacity(0.5))),
                            AutoSizeText(
                              widget.lesson.oneYear != null
                                  ? _parseHtmlString(widget.lesson.oneYear)
                                  : "",
                              style:
                                  TextStyle(fontSize: 11, color: Colors.white),
                              minFontSize: 6,
                              maxLines: 3,
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            )),
          ]));
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text(
            "${widget.lesson.day.name}/${widget.lesson.month.name}/${widget.lesson.year.name}"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.calendar_today,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
              _selectDate(context);

              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => widget.type == 1
              //             ? ListPage(type: 1)
              //             : AnchorsPage(type: 2)));
              // showModalBottomSheet(
              //     context: context,
              //     builder: (BuildContext context) {
              //       return _generateTags();
              //     });
            },
          ),
          if (widget.type == 1)
            IconButton(
              icon: Icon(
                Icons.comment,
                color: Colors.white,
              ),
              onPressed: () {
                // do something
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CommentsPage(widget.lesson.uuid)));
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
      body: Container(padding: EdgeInsets.all(30), child: makeBody()),
    );
  }
}
// class _ParallaxPageState extends State<ParallaxPage> {
