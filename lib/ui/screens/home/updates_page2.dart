import "dart:convert";

import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app/models/NewsArticle.dart';
import 'package:app/models/Updates.dart';
import 'package:app/pages/details/update_details.dart';
import 'package:app/services/webservice.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class UpdatesPage2 extends StatefulWidget {
  UpdatesPage2({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _UpdatesPage2State createState() => _UpdatesPage2State();
}

class _UpdatesPage2State extends State<UpdatesPage2> {
  // THE "StaggeredGridView" SCROLLCONTROLLER
  ScrollController _controller;
  var _isLoading = true, _isInit = false;
  // final storyController = StoryController();
  // @override
  // void dispose() {
  //   storyController.dispose();
  //   super.dispose();
  // }

  // URL TO FETCH IMAGES
  final String url = "https://api.unsplash.com/photos";

  // BREAKPOINTS FOR RESPONSIVITY
  final List<double> breakpoints = [1100, 900, 600, 300, 200];
  final List<int> breakpointsValues = [6, 4, 3, 2, 1];
  List<Updates> _newsArticles = List<Updates>();

  // ARRAY OF IMAGE LINKS TO RENDER IN A IMAGE WIDGET
  List<String> imagesURL = [];

  void _populateNewsArticles() {
    Webservice().load(Updates.all).then((newsArticles) => {
          setState(() => {_newsArticles = newsArticles})
        });
  }

  // //FUNCTION TO LOAD MORE IMAGES
  // Future<void> fetchImages() async {
  //   try {
  //     String clientId = DotEnv().env['UNSPLASH_ACCESS_KEY'];

  //     var response = await http
  //         .get(url, headers: {"Authorization": "Client-ID $clientId"});

  //     List<dynamic> images = jsonDecode(response.body);

  //     print(response.body);
  //     setState(() {
  //       images.forEach((imageDetails) {
  //         imagesURL.add(imageDetails["urls"]["regular"]);
  //       });
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // LISTENER OF SCROLLCONTROLLER
  void _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      _populateNewsArticles();
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    if (!_isInit) {
      _simulateLoad();
    }
    _isInit = true;

    // fetchImages();

    super.initState();
  }

  Future _simulateLoad() async {
    Future.delayed(Duration(seconds: 5), () {
      _populateNewsArticles();
      setState(() {
        _isLoading = false;
      });
    });
  }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Text("Updates"),
//         centerTitle: true,
//         actions: <Widget>[
//           FlatButton(
//             textColor: Colors.white,
//             onPressed: () {},
//             child: Text("view more"),
//             shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
//           ),
//         ],
//       ),
//       body: StoryView(
//         [
//           //The StoryItem.text accepts a text, you can add any text you want
//           StoryItem.text(
//               "WOW !!! i built my first status story", Colors.pinkAccent,
//               fontSize: 25),

//           //The StoryItem.pageImage accepts an image, you can add any image you want
//           //In this tutorial, Cached Network Image Provider was used so as to load the image and also cache images
//           //StoryItem.pageImage accepts a caption
//           //The caption describes the image
//           StoryItem.pageImage(
//             CachedNetworkImageProvider(
//                 "https://i.pinimg.com/originals/f6/eb/53/f6eb535411056b553dfdec1665387c0c.jpg"),
//             caption: "Simply beautiful😘😘😘",
//           ),
//           StoryItem.pageImage(
//             CachedNetworkImageProvider(
//                 "https://i.pinimg.com/originals/f6/eb/53/f6eb535411056b553dfdec1665387c0c.jpg"),
//             caption: "Simply beautiful😘😘😘",
//           ),
//           StoryItem.pageImage(
//             CachedNetworkImageProvider(
//                 "http://s3.weddbook.com/t4/2/5/0/2501568/vanila-wedding-boutique-dubai-on-instagram-have-a-lovely-weekend-everyone-let-it-be-sunny-throughout-the-upcoming-days-to-enjoy-the-beach-and-the-sea-our-lovely-vanila-bride.jpg"),
//             caption: "Vanila Wedding Boutique Dubai",
//           ),
//           StoryItem.pageImage(
//             CachedNetworkImageProvider(
//                 "https://i0.pickpik.com/photos/836/957/310/adventure-jump-hipster-ext-preview.jpg"),
//             caption: "Jumping beside cliff during daytime",
//           ),

//           StoryItem.pageImage(
//             CachedNetworkImageProvider(
//                 "https://i0.pickpik.com/photos/836/957/310/adventure-jump-hipster-ext-preview.jpg"),
//             caption: "Jumping beside cliff during daytime",
//           ),
//           StoryItem.pageImage(
//             CachedNetworkImageProvider(
//                 "https://i0.pickpik.com/photos/836/957/310/adventure-jump-hipster-ext-preview.jpg"),
//             caption: "Jumping beside cliff during daytime",
//           ),
//           //The StoryItem.pageGif accepts a GIf, you can add any Gif you want
//           //It accepts a caption. The caption describes the Gif
//           // StoryItem.pageGif(
//           //   "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
//           //   caption: "Thanks for watching",
//           //   controller: storyController,
//           // ),

//           //The StoryItem.pageVideo accepts a Video.
//           //It accepts a caption. The caption describes the video
//           // StoryItem.pageVideo(
//           // "https://firebasestorage.googleapis.com/v0/b/tactile-timer-267314.appspot.com/o/Hang%20-%2030902.mp4?alt=media&token=74eec54b-7c4a-43dc-bd7a-522a494b69c0",
//           // caption: "title of the video",
//           // controller: storyController,
//           // shown: true,
//           // duration: Duration(m)
//           // ),
//         ],
//         onStoryShow: (s) {
//           print("Showing a story");
//         },
//         onComplete: () {
//           print("Completed a cycle");
//         },
//         progressPosition: ProgressPosition.top,
//         repeat: true,

//         // controller: storyController,
//       ),
//     );
//   }
// }
  @override
  Widget build(BuildContext context) {
    int columnsLength = 0;

    double width = MediaQuery.of(context).size.width;

    for (int i = 0; i < breakpoints.length; i++) {
      double breakpoint = breakpoints[i];

      if (width >= breakpoint) {
        columnsLength = breakpointsValues[i];
        break;
      }
    }
    //  List<String> exampleList = ["A", "B", "C", "D", "E", "F", "G", "H"];

    return Scaffold(
      appBar: AppBar(title: Text('NIFES UPDATES')),
      body: _isLoading
          ? SkeletonGridLoader(
              builder: Card(
                color: Colors.transparent,
                child: GridTile(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 50,
                        height: 10,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 70,
                        height: 10,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              items: 9,
              itemsPerRow: 3,
              period: Duration(seconds: 2),
              highlightColor: Colors.lightBlue[300],
              direction: SkeletonDirection.ltr,
              childAspectRatio: 1,
            )
          : GridView.builder(
              itemCount: _newsArticles.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) {
                return Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Image.network(
                      _newsArticles[index].urlToImage,
                      fit: BoxFit.cover,
                    ),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: GestureDetector(
                          onTap: () {
                            print("Container was tapped");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateDetails(
                                        lesson: _newsArticles[index],
                                        type: 2)));
                          },
                          child: Container(
                            padding: EdgeInsets.all(16.0),
                            color: Colors.black38,
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('${_newsArticles[index].title}',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                ),
                                //  Icon(Icons.star_border, color: Colors.white),
                              ],
                            ),
                          ),
                        ))
                  ],
                );
              },
            ),
    );
  }
}

class _Tile extends StatelessWidget {
  final int index;
  final String url;

  _Tile(this.index, this.url);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        child: Stack(children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
                child: CircularProgressIndicator(),
                alignment: Alignment.center,
                height: 60),
          ),
          Align(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: url,
              ),
            ),
          ),
        ]));
  }
}
