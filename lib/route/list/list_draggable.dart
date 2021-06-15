import 'package:flutter/material.dart';
import 'package:app/adapter/list_basic_adapter.dart';
import 'package:app/adapter/list_draggable_adapter.dart';
import 'package:app/data/dummy.dart';
import 'package:app/model/people.dart';
import 'package:app/widget/toolbar.dart';
import 'package:toast/toast.dart';

class ListDraggableRoute extends StatefulWidget {
  ListDraggableRoute();

  @override
  ListDraggableRouteState createState() => new ListDraggableRouteState();
}

class ListDraggableRouteState extends State<ListDraggableRoute> {
  BuildContext context;
  List<People> items;

  void onReorder() {
    setState(() {});
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
      appBar: CommonAppBar.getPrimaryAppbar(context, "Draggable"),
      body: ListDraggableAdapter(items, onReorder).getView(),
    );
  }
}
