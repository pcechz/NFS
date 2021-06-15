import 'package:flutter/material.dart';
import 'package:app/components/splash/widget/splash_widget.dart';
import 'package:app/configs/colors.dart';

class SplashRepository {
  Widget loadWidget() {
    return SplashWidget(title: "NIFES", image: "assets/images/logo.png");
  }
}
