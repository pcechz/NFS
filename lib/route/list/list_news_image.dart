import 'package:flutter/material.dart';
import 'package:app/adapter/list_news_image_adapter.dart';
import 'package:app/data/dummy.dart';
import 'package:app/data/my_colors.dart';
import 'package:app/model/news.dart';
import 'package:toast/toast.dart';

class ListNewsImageRoute extends StatefulWidget {
  ListNewsImageRoute();

  @override
  ListNewsImageRouteState createState() => new ListNewsImageRouteState();
}

class ListNewsImageRouteState extends State<ListNewsImageRoute> {
  BuildContext context;
  void onItemClick(int index, News obj) {
    Toast.show("News " + index.toString() + "clicked", context,
        duration: Toast.LENGTH_SHORT);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    List<News> items = Dummy.getNewsData(10);
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              brightness: Brightness.dark,
              backgroundColor: Colors.grey[900],
              title:
                  Text("News Image", style: TextStyle(color: MyColors.grey_10)),
              leading: IconButton(
                icon: Icon(Icons.menu, color: MyColors.grey_10),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search, color: MyColors.grey_10),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.more_vert, color: MyColors.grey_10),
                  onPressed: () {},
                ), // overflow menu
              ]),
          ListNewsImageAdapter(items, onItemClick).getView()
        ],
      ),
    );
  }
}
