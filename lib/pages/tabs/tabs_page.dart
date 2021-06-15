import 'package:flutter/material.dart';
import 'package:app/components/follow/widget/follow.dart';
import 'package:app/components/profile/widget/profile.dart';
import 'package:app/components/rates/widget/rates.dart';
import 'package:app/menu/default_layout.dart';

class TabsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /** At the top you must import whatever page you would like to display in your app */
    /** As usual, we return the Layout() widget, but this time we pass in to the @tabs param */
    /** for the key - Tab name, and value - Tab page with appBar set to false to avoid double appBars */
    return Layout(backButton: true, title: 'TABS', tabs: {
      'FOLLOW': Follow(appBar: false),
      'RATES': Rates(appBar: false),
      'PROFILE': Profile(appBar: false)
    });
  }
}
