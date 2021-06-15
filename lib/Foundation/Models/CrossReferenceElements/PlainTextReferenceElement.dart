import 'package:app/Foundation/Models/CrossReferenceElements/ICrossReferenceElement.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/painting/inline_span.dart';

class PlainTextReferenceElement extends ICrossReferenceElement {
  PlainTextReferenceElement({text}) : super(text: text);

  @override
  TextSpan toInlineSpan(BuildContext context) {
    // TODO: implement toInlineSpan
    return TextSpan(text: text);
  }
}
