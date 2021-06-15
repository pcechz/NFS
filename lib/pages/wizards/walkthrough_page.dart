import 'package:flutter/material.dart';
import 'package:app/components/walkthrough/repository/WalkthroughRepository.dart';
import 'package:app/components/walkthrough/widget/walkthrough.dart';
import 'package:app/menu/default_layout.dart';

class WalkthroughPage extends StatelessWidget {
  void _onButtonClick(BuildContext context) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text("Clicked on button")));
  }

  // The Screen build
  @override
  Widget build(BuildContext context) {
    return Layout(
        backButton: true,
        title: "WALKTHROUGH",
        body: Walkthrough(
            pages: WalkthoughtRepository().loadWidgets(),
            buttonText: 'BUY NOW',
            onButtonClick: _onButtonClick));
  }
}
