import 'package:flutter/material.dart';
import 'package:app/routers/routes.dart';

class Category {
  const Category({
    @required this.name,
    @required this.color,
    @required this.route,
  });

  final Color color;
  final String name;
  final Routes route;
}
