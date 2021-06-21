import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:app/model/lesson.dart';
import 'package:app/models/Anchors.dart';
import 'package:app/models/Updates.dart';
import 'package:app/ui/screens/home/widgets/CommentsPage.dart';
import 'parallax_component.dart';
// import 'package:fluttertagselector/fluttertagselector.dart';
// import 'package:esv_api/esv_api.dart';

class UpdateDetails extends StatefulWidget {
  final Updates lesson;
  final int type;
  UpdateDetails({Key key, this.lesson, this.type}) : super(key: key);
  @override
  _UpdateDetailsState createState() => _UpdateDetailsState();
}

class _UpdateDetailsState extends State<UpdateDetails> {
  List<String> selectedTags = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("${widget.lesson.title ?? ""}"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
            child: Html(
          data: widget.lesson.descrption ?? "",
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
        )),
      ),
    );
  }
}
// class _ParallaxPageState extends State<ParallaxPage> {
