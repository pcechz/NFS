import 'package:flutter/material.dart';
import 'package:app/configs/colors.dart';
import 'package:app/domain/entities/category.dart';
import 'package:app/routers/routes.dart';
//import 'package:app/routers/routes.dart';

const List<Category> categories = [
  Category(name: 'Anchor', color: AppColors.teal, route: Routes.expandable),
  Category(name: 'NVM', color: AppColors.red, route: Routes.expandable),
  Category(
      name: 'NIFES Updates', color: AppColors.blue, route: Routes.expandable),
  Category(name: 'Bible', color: AppColors.yellow, route: Routes.pokedex),
  Category(
      name: 'Prayer Bulletin', color: AppColors.purple, route: Routes.bulletin),
  Category(
      name: 'Land of Promise',
      color: AppColors.brown,
      route: Routes.expandable),
];
