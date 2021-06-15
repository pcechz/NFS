import 'package:flutter/material.dart';
import 'package:app/components/common/card/profile_card.dart';

class ProfileRepository {
  List<Widget> loadWidgets() {
    return [
      Container(
        height: 200.0,
        color: Colors.transparent,
      ),
      ProfileCard(
        icon: 'assets/avatars/avatar_1.jpg',
        name: 'Peter Esan',
        description:
            'Roident est duis duis sit occaecat ea eius mod laboris mollit ullamco mollit nisi veniam',
        firstColumnNum: '3450',
        firstColumnCat: 'Posts',
        secondColumnNum: '41',
        secondColumnCat: 'Comments',
        thirdColumnNum: '93',
        thirdColumnCat: 'About',
      )
    ];
  }
}
