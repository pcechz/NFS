import 'package:flutter/material.dart';
import 'package:app/adapter/list_basic_adapter.dart';
import 'package:app/adapter/list_swipe_adapter.dart';
import 'package:app/data/dummy.dart';
import 'package:app/model/people.dart';
import 'package:app/widget/toolbar.dart';
import 'package:toast/toast.dart';

class ListSwipeRoute extends StatefulWidget {
  ListSwipeRoute();

  @override
  ListSwipeRouteState createState() => new ListSwipeRouteState();
}

class ListSwipeRouteState extends State<ListSwipeRoute> {
  BuildContext context;
  List<People> items;

  void onItemSwipe(int index, People obj) {
    setState(() {
      items.removeAt(index);
    });
    Toast.show(obj.name + " dismissed", context, duration: Toast.LENGTH_SHORT);
  }

  @override
  void initState() {
    super.initState();
    items = Dummy.getPeopleData();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return new Scaffold(
      appBar: CommonAppBar.getPrimaryAppbar(context, "Swipe"),
      body: ListSwipeAdapter(items, onItemSwipe).getView(),
    );
  }
}
