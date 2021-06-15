import 'package:flutter/material.dart';
import 'package:app/adapter/list_basic_adapter.dart';
import 'package:app/adapter/list_news_light_hrzntl_adapter.dart';
import 'package:app/data/dummy.dart';
import 'package:app/data/my_colors.dart';
import 'package:app/model/news.dart';
import 'package:app/model/people.dart';
import 'package:app/widget/toolbar.dart';
import 'package:toast/toast.dart';

class ListNewsLightHrzntlRoute extends StatefulWidget {
  ListNewsLightHrzntlRoute();

  @override
  ListNewsLightHrzntlRouteState createState() =>
      new ListNewsLightHrzntlRouteState();
}

class ListNewsLightHrzntlRouteState extends State<ListNewsLightHrzntlRoute> {
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
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              title: Text("News Light Hrzntl",
                  style: TextStyle(color: MyColors.grey_60)),
              leading: IconButton(
                icon: Icon(Icons.menu, color: MyColors.grey_60),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search, color: MyColors.grey_60),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.more_vert, color: MyColors.grey_60),
                  onPressed: () {},
                ), // overflow menu
              ]),
          ListNewsLightHrzntlAdapter(items, onItemClick).getView()
        ],
      ),
    );
  }
}
