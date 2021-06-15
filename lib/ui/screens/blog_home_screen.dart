import 'dart:convert';

import 'package:app/model/blog_model.dart';
import 'package:app/ui/screens/blog_screen.dart';
import 'package:app/ui/widgets/blog_posts.dart';
import 'package:app/ui/widgets/recent_posts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app/utils/constants.dart';

class BlogHomeScreen extends StatefulWidget {
  @override
  _BlogHomeScreenState createState() => _BlogHomeScreenState();
}

class _BlogHomeScreenState extends State<BlogHomeScreen> {
  List<Blog> _posts = List<Blog>();

  @override
  void initState() {
    super.initState();
    _populatePosts();
  }

  Future<void> _populatePosts() async {
    final http.Response response = await http.get(Constants.HEADLINE_NEWS_URL);
    final Map<String, dynamic> responseData = json.decode(response.body);

    responseData['data'].forEach((newsDetail) {
      //  print("thees${newsDetail['image'].substring(22)}");
      final Blog news = Blog(
          name: newsDetail['title'],
          content: newsDetail['body'],
          imageUrl:
              newsDetail['image'] ?? Constants.NEWS_PLACEHOLDER_IMAGE_ASSET_URL,
          // 'https://nifes.org.ng/' + newsDetail['image'].substring(19) ??
          // Constants.NEWS_PLACEHOLDER_IMAGE_ASSET_URL,
          slug: newsDetail['slug'],
          created_at: newsDetail['created_at']);
      setState(() {
        _posts.add(news);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            iconSize: 20.0,
            onPressed: () {
              _goBack(context);
            },
          ),
          centerTitle: true,
          title: Text('Blog')),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  height: MediaQuery.of(context).size.width * 0.90,
                  color: Colors.white,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _posts.length,
                    itemBuilder: (BuildContext context, int index) {
                      //final Blog blog = _posts[index];
                      return GestureDetector(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      BlogScreen(blog: _posts[index])))
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 20.0, top: 20.0, bottom: 20.0),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.80,
                                  height:
                                      MediaQuery.of(context).size.width * 0.90,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14.0),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(0.0, 4.0),
                                            blurRadius: 10.0,
                                            spreadRadius: 0.10)
                                      ]),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(14.0),
                                      child: _posts[index].imageUrl == null
                                          ? Image.asset(
                                              Constants
                                                  .NEWS_PLACEHOLDER_IMAGE_ASSET_URL,
                                              fit: BoxFit.cover)
                                          : Image.network(
                                              _posts[index].imageUrl,
                                              fit: BoxFit.cover))),
                              Positioned(
                                bottom: 10.0,
                                left: 10.0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.60,
                                      child: Text(
                                        _posts[index].name ?? "",
                                        style: TextStyle(
                                          fontSize: 22.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.6,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        CircleAvatar(
                                            radius: 10.0,
                                            backgroundImage: AssetImage(
                                                'assets/images/photo_female_1.jpg')),
                                        SizedBox(width: 8.0),
                                        Text("admin",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0)),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 10.0,
                                right: 10.0,
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.timer,
                                      size: 10.0,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 5.0),
                                    Text(_posts[index].created_at ?? "",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.0,
                                        ))
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 10.0,
                                right: 10.0,
                                child: Icon(Icons.bookmark,
                                    size: 26.0, color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 5.0),
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Recent Posts",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "See all",
                          style: TextStyle(
                              color: Colors.lightBlueAccent, fontSize: 16.0),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _posts
                          .map((blog) => GestureDetector(
                              onTap: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                BlogScreen(blog: blog)))
                                  },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 15.0),
                                width: MediaQuery.of(context).size.width,
                                height: 140,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color(0xFFFAFAFA),
                                          offset: Offset(0.0, 10.0),
                                          blurRadius: 10.0,
                                          spreadRadius: 0.5)
                                    ]),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 20.0),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.22,
                                        height: 110,
                                        decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: blog.imageUrl == null
                                              ? Image.asset(
                                                  Constants
                                                      .NEWS_PLACEHOLDER_IMAGE_ASSET_URL,
                                                  fit: BoxFit.fill)
                                              : Image.network(blog.imageUrl,
                                                  fit: BoxFit.fill),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.66,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(height: 5.0),
                                            Text(
                                              "admin",
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            SizedBox(height: 5.0),
                                            Container(
                                              height: 58,
                                              child: Text(
                                                blog.name ?? "",
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.timer,
                                                      color: Colors.grey,
                                                      size: 12.0,
                                                    ),
                                                    SizedBox(width: 5.0),
                                                    Text(
                                                      blog.created_at ?? "",
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(width: 20.0),
                                                Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.remove_red_eye,
                                                      color: Colors.grey,
                                                      size: 12.0,
                                                    ),
                                                    SizedBox(width: 5.0),
                                                    Text(
                                                      "",
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )))
                          .toList()),
                )
              ],
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
