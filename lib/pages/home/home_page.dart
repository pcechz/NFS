import 'package:app/configs/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:app/components/common/style/styles.dart';
import 'package:app/menu/default_layout.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Layout(
        title: "nfs",
        body:
            /** Comment out the block bellow to make an empty page */
            Container(
          child: Center(
            child: IconButton(
              // padding: EdgeInsets.all(24),
              icon: Icon(Icons.notifications),
              color: AppColors.blue,

              onPressed: () {
                print("");
              },
            ),

            // Text("Welcome!",
            //     style: TextStyle(
            //         color: Styles.helperTextColor,
            //         fontWeight: Styles.lightFont,
            //         fontSize: Styles.h1)),
          ),
        ));
  }
}
