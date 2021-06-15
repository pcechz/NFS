import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/data/dummy.dart';
import 'package:app/data/img.dart';
import 'package:app/data/my_colors.dart';
import 'package:app/model/wizard.dart';
import 'package:app/widget/my_text.dart';
import 'package:app/widget/toolbar.dart';

class SteppersWizardColorRoute extends StatefulWidget {
  SteppersWizardColorRoute();

  @override
  SteppersWizardColorRouteState createState() =>
      new SteppersWizardColorRouteState();
}

class SteppersWizardColorRouteState extends State<SteppersWizardColorRoute> {
  List<Wizard> wizardData = Dummy.getWizard();
  PageController pageController = PageController(
    initialPage: 0,
  );
  int page = 0;
  bool isLast = false;
  Wizard wizard;
  @override
  void initState() {
    super.initState();
    wizard = wizardData[0];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Container(color: wizard.color)),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                PageView(
                  onPageChanged: onPageViewChange,
                  controller: pageController,
                  children: buildPageViewItem(),
                ),
                Row(
                  children: <Widget>[
                    Spacer(),
                    ButtonTheme(
                      minWidth: 10,
                      child: FlatButton(
                        child: Text("SKIP",
                            style: MyText.subhead(context).copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500)),
                        color: Colors.transparent,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      isLast
                          ? Container(
                              width: 100,
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(18.0)),
                                child: Text(
                                  "GOT IT",
                                  style: TextStyle(color: MyColors.grey_80),
                                ),
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            )
                          : Container(),
                      Container(height: 10),
                      Container(
                        height: 45,
                        child: Align(
                          alignment: Alignment.center,
                          child: buildDots(context),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }

  void onPageViewChange(int _page) {
    page = _page;
    isLast = _page == wizardData.length - 1;
    setState(() {
      wizard = wizardData[_page];
    });
  }

  List<Widget> buildPageViewItem() {
    List<Widget> widgets = [];
    for (Wizard wz in wizardData) {
      Widget wg = Container(
        color: wz.color,
        padding: EdgeInsets.all(35),
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        child: Wrap(
          children: <Widget>[
            Container(
                width: 280,
                child: Stack(
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(35),
                          child: Image.asset(Img.get(wz.image),
                              width: 150, height: 150, color: Colors.white),
                        ),
                        Text(wz.title,
                            style: MyText.medium(context).copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 25),
                          child: Text(wz.brief,
                              textAlign: TextAlign.center,
                              style: MyText.subhead(context)
                                  .copyWith(color: MyColors.grey_10)),
                        ),
                      ],
                    )
                  ],
                ))
          ],
        ),
      );
      widgets.add(wg);
    }
    return widgets;
  }

  Widget buildDots(BuildContext context) {
    Widget widget;

    List<Widget> dots = [];
    for (int i = 0; i < wizardData.length; i++) {
      Widget w = Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        height: 8,
        width: 8,
        child: CircleAvatar(
          backgroundColor:
              page == i ? MyColors.grey_10 : Colors.black.withOpacity(0.3),
        ),
      );
      dots.add(w);
    }
    widget = Row(
      mainAxisSize: MainAxisSize.min,
      children: dots,
    );
    return widget;
  }
}
