import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/image_render.dart';
import 'package:app/model/blog_model.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/Constants.dart';

class BlogScreen extends StatefulWidget {
  @override
  final Blog blog;

  BlogScreen({this.blog});
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     leading: IconButton(
      //       icon: Icon(Icons.arrow_back_ios),
      //       iconSize: 20.0,
      //       onPressed: () {
      //         _goBack(context);
      //       },
      //     ),
      //     centerTitle: true,
      //     title: Text(widget.blog.name)),
      // appBar: AppBar(
      //     leading: IconButton(
      //       icon: Icon(Icons.arrow_back_ios),
      //       iconSize: 20.0,
      //       onPressed: () {
      //         _goBack(context);
      //       },
      //     ),
      //     centerTitle: true,
      //     title: Text('Blog')),
      // backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.45,
                    child: ClipRRect(child: widget.blog.imageUrl == null ? Image.asset(Constants.NEWS_PLACEHOLDER_IMAGE_ASSET_URL, fit: BoxFit.cover) : Image.network(widget.blog.imageUrl, fit: BoxFit.cover)),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(60.0), topRight: Radius.circular(60.0)),
                      ),
                      child: SizedBox(width: 1),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 0,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.blue[900],
                              size: 30,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          // Icon(
                          //   Icons.bookmark_border,
                          //   color: Colors.white,
                          //   size: 30,
                          // )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 1500,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.blog.name,
                      style: TextStyle(fontSize: 28.0, color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "⭐ 4.5",
                          style: TextStyle(fontSize: 18.0, color: Colors.grey),
                        ),
                        SizedBox(width: 20.0),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.timer,
                              color: Colors.grey,
                              size: 16.0,
                            ),
                            SizedBox(width: 2.0),
                            Text(
                              widget.blog.created_at,
                              style: TextStyle(color: Colors.grey, fontSize: 16.0),
                            )
                          ],
                        ),
                        SizedBox(width: 20.0),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.remove_red_eye,
                              color: Colors.grey,
                              size: 16.0,
                            ),
                            SizedBox(width: 2.0),
                            // Text(
                            //   "7k Views",
                            //   style:
                            //       TextStyle(color: Colors.grey, fontSize: 16.0),
                            // )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: AssetImage('photo_female_1.jpg'),
                          radius: 28.0,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          "admin",
                          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, letterSpacing: 0.8),
                        )
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Html(
                      data: widget.blog.content,
                      //Optional parameters:
                      customImageRenders: {
                        networkSourceMatcher(domains: ["flutter.dev"]): (context, attributes, element) {
                          return FlutterLogo(size: 36);
                        },
                        networkSourceMatcher(domains: ["mydomain.com"]): networkImageRender(
                          headers: {"Custom-Header": "some-value"},
                          altWidget: (alt) => Text(alt),
                          loadingWidget: () => Text("Loading..."),
                        ),
                        // On relative paths starting with /wiki, prefix with a base url
                        (attr, _) => attr["src"] != null && attr["src"].startsWith("/wiki"): networkImageRender(mapUrl: (url) => "https://upload.wikimedia.org" + url),
                        // Custom placeholder image for broken links
                        networkSourceMatcher(): networkImageRender(altWidget: (_) => FlutterLogo()),
                      },
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
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
