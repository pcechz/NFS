import 'package:flutter/material.dart';
import 'package:app/components/common/card/component_card.dart';
import 'package:app/menu/component/component_list.dart';
import 'package:app/routers/routes.dart';

class CardsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ComponentList(
      title: "CARDS",
      componentCards: [
        ComponentCard(
          text: 'Rates',
          route: Rout.rates,
          icon: Icons.poll,
          margin: EdgeInsets.symmetric(vertical: 5.0),
        ),
        ComponentCard(
          text: 'Follow',
          route: Rout.follow,
          icon: Icons.supervised_user_circle,
          margin: EdgeInsets.symmetric(vertical: 5.0),
        ),
        ComponentCard(
          text: 'Profile',
          route: Rout.profile,
          icon: Icons.supervised_user_circle,
          margin: EdgeInsets.symmetric(vertical: 5.0),
        ),
      ],
    );
  }
}
