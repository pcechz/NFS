import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/image_render.dart';
import 'package:app/models/Anchors.dart';
import 'package:app/services/webservice.dart';
import 'package:app/utils/constants.dart';
import 'package:http/http.dart' as http;

class AnchorPage extends StatefulWidget {
  AnchorPage({Key key}) : super(key: key);

  State<StatefulWidget> createState() => _AnchorPageState();
}

class _AnchorPageState extends State<AnchorPage> {
  List<Anchors> _anchors = List<Anchors>();

  @override
  void initState() {
    super.initState();
    _populateAnchors();
    //getNews();
  }

  Future<void> _populateAnchors() async {
    final http.Response response = await http.get(Uri.parse("https://nifes.org.ng/api/mobile/anchor/index"));
    final Map<String, dynamic> responseData = json.decode(response.body);

    responseData['anchors'].forEach((newsDetail) {
      final Anchors news = Anchors(description: newsDetail['description'], uuid: newsDetail['uuid'], createdAt: newsDetail['created_at']);
      setState(() {
        _anchors.add(news);
      });
    });
  }

  Widget build(BuildContext context) {
    final levelIndicator = Container(
      child: Container(
        child: LinearProgressIndicator(backgroundColor: Color.fromRGBO(209, 224, 224, 0.2), value: 100, valueColor: AlwaysStoppedAnimation(Colors.green)),
      ),
    );

    final coursePrice = Container(
      padding: const EdgeInsets.all(7.0),
      decoration: new BoxDecoration(border: new Border.all(color: Colors.white), borderRadius: BorderRadius.circular(5.0)),
      child: new Text(
        "New",
        style: TextStyle(color: Colors.white),
      ),
    );

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 120.0),
        Icon(
          Icons.directions_car,
          color: Colors.white,
          size: 40.0,
        ),
        Container(
          width: 90.0,
          child: new Divider(color: Colors.green),
        ),
        SizedBox(height: 10.0),
        Text(
          _anchors.first.createdAt,
          style: TextStyle(color: Colors.white, fontSize: 45.0),
        ),
        SizedBox(height: 30.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(flex: 1, child: levelIndicator),
            Expanded(
                flex: 6,
                child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      "Anchor",
                      style: TextStyle(color: Colors.white),
                    ))),
            Expanded(flex: 1, child: coursePrice)
          ],
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("image_27.jpg"),
                fit: BoxFit.cover,
              ),
            )),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
          child: Center(
            child: topContentText,
          ),
        ),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        )
      ],
    );

    final bottomContentText = Html(
      data: _anchors.first.description,
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
    );
    // final readButton = Container(
    //     padding: EdgeInsets.symmetric(vertical: 16.0),
    //     width: MediaQuery.of(context).size.width,
    //     child: RaisedButton(
    //       onPressed: () => {},
    //       color: Color.fromRGBO(58, 66, 86, 1.0),
    //       child:
    //           Text("TAKE THIS LESSON", style: TextStyle(color: Colors.white)),
    //     ));
    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: <Widget>[bottomContentText],
        ),
      ),
    );

    return Scaffold(
      body: Column(
        children: <Widget>[topContent, bottomContent],
      ),
    );
  }
}
