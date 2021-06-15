import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/image_render.dart';
import 'package:app/models/Anchors.dart';
import 'package:app/services/webservice.dart';
import 'package:app/utils/constants.dart';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  DetailPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DetailPageState createState() => new _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<Anchors> _anchors = List<Anchors>();
  @override
  void initState() {
    super.initState();
    _populateAnchors();
    //getNews();
  }

  Future<void> _populateAnchors() async {
    final http.Response response =
        await http.get("https://nifes.org.ng/api/mobile/anchor/index");
    final Map<String, dynamic> responseData = json.decode(response.body);

    responseData['anchors'].forEach((newsDetail) {
      final Anchors news = Anchors(
          description: newsDetail['body'],
          uuid: newsDetail['uuid'],
          createdAt: newsDetail['createdAt']);
      setState(() {
        _anchors.add(news);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_anchors.first.uuid);
    return new Scaffold(
      appBar: AppBar(
        title: Text(""),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: (_anchors == null)
            ? CircularProgressIndicator()
            : Html(
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
                onLinkTap: (url) {
                  print("Opening $url...");
                },
                onImageTap: (src) {
                  print(src);
                },
                onImageError: (exception, stackTrace) {
                  print(exception);
                },
              ),
      ),
    );
  }
}
