import 'package:app/Feature/History/Views/HistoryIndex.dart';
import 'package:app/Feature/InheritedBlocs.dart';
import 'package:app/Feature/Navigation/navigation_feature.dart';
import 'package:app/Foundation/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:notus/notus.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HistoryIndex(),
      bottomNavigationBar: BibleBottomNavigationBar(context: context),
    );
  }
}
