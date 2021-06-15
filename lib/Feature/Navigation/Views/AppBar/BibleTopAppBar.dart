import 'package:app/Feature/Reader/reader_feature.dart';
import 'package:app/Feature/Search/search_feature.dart';
import 'package:flutter/material.dart';
import 'package:app/routers/routes.dart';

class BibleReaderAppBar extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  const BibleReaderAppBar({
    Key key,
    this.title,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => Rout.home),
        ),
      ),
      pinned: true,
      centerTitle: true,

      /* leading: IconButton(
        icon: Icon(Icons.search),
        onPressed: () => showSearch(
              context: context,
              delegate: BibleSearchDelegate(),
            ),
      ), */
      title: GestureDetector(
        onTap: () {
          showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Container(child: BooksList());
              });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(title),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
      /* actions: <Widget>[
        SettingsPopupMenu(),
      ],*/
      actions: actions,
    );
  }
}
