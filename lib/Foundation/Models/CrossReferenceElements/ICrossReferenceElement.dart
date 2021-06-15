import 'package:flutter/cupertino.dart';

abstract class ICrossReferenceElement {
  String text;

  ICrossReferenceElement({this.text});

  TextSpan toInlineSpan(BuildContext context);
}
