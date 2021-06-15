import 'package:flutter/material.dart';
import 'package:app/routers/routes.dart';

class MenuRepository {
  Map<Widget, Map<String, IconData>> loadModel() {
    return {
      Rout.components: {'LISTS': Icons.format_list_bulleted},
      Rout.cardList: {'CARDS': Icons.credit_card},
      Rout.walkthrough: {'ONBOARDING / WIZARDS': Icons.view_array},
      Rout.login: {'LOGIN / REGISTER': Icons.input},
      Rout.gallery: {'GALLERY': Icons.image},
      Rout.checkboxSliders: {'SMALL COMPONENTS': Icons.tune},
      Rout.parallaxList: {'PARALLAX': Icons.layers},
      Rout.tabs: {'TABS': Icons.layers},
      Rout.dialogList: {'DIALOGS': Icons.chat}
    };
  }
}
