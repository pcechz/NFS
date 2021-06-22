import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:app/model/lesson.dart';
import 'package:html/parser.dart';
import 'package:app/models/Anchors.dart';
import 'package:app/ui/screens/home/widgets/CommentsPage.dart';
import 'parallax_component.dart';
// import 'package:fluttertagselector/fluttertagselector.dart';
// import 'package:esv_api/esv_api.dart';

class ParallaxPage extends StatefulWidget {
  final Anchors lesson;
  final int type;
  ParallaxPage({Key key, this.lesson, this.type}) : super(key: key);
  @override
  _ParallaxPageState createState() => _ParallaxPageState();
}

class _ParallaxPageState extends State<ParallaxPage> {
  List<String> selectedTags = [];

  @override
  void initState() {
    super.initState();
    print("theverse+${widget.lesson.verses}");
    if (widget.lesson.verses != null) {
      selectedTags = widget.lesson.verses.split(",");
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
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Card(
                      color: Colors.white.withOpacity(0.5),
                      elevation: 5,
                      margin: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
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
                                    color: Colors.black.withOpacity(0.5))),
                            AutoSizeText(
                              widget.lesson.topic.length > 0
                                  ? _parseHtmlString(widget.lesson.topic)
                                  : "",
                              style: TextStyle(
                                  fontSize: 23,
                                  color: Colors.white.withOpacity(0.5)),
                              minFontSize: 8,
                              maxLines: 4,
                            ),
                          ],
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 10.0),
                  ),
                  Card(
                      color: Colors.black.withOpacity(0.5),
                      elevation: 5,
                      margin: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        height: 50,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 5.0),
                            ),
                            Text("Bible Reading",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black.withOpacity(0.5))),
                            AutoSizeText(
                              widget.lesson.bibleReading.length > 0
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
                    padding: EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 10.0),
                  ),
                  Card(
                      color: Colors.purple.withOpacity(0.5),
                      elevation: 5,
                      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(color: Colors.white, width: 1),
                              right: BorderSide(color: Colors.green, width: 5),
                              left: BorderSide(color: Colors.purple, width: 5)),
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
                              widget.lesson.wordOFToday.length > 0
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
                      ))
                ],
              ),
            ),
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
