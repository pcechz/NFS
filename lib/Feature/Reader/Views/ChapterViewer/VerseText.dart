import 'package:app/Foundation/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:after_layout/after_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerseText extends StatefulWidget {
  final Book book;
  final Chapter chapter;
  final Function scrollToVerseMethod;
  final int verseNumber;
  final bool showReferences;
  final double fontSize;

  const VerseText({
    Key key,
    @required this.book,
    @required this.chapter,
    this.verseNumber,
    this.scrollToVerseMethod,
    this.showReferences,
    this.fontSize,
  }) : super(key: key);

  @override
  _VerseTextState createState() => _VerseTextState(
        scrollToVerseMethod: scrollToVerseMethod,
        book: book,
        chapter: chapter,
        verseNumber: verseNumber,
      );
}

class _VerseTextState extends State<VerseText>
    with AfterLayoutMixin<VerseText> {
  final Book book;
  final Chapter chapter;
  final TextSpan chapterText;
  final Function scrollToVerseMethod;
  final int verseNumber;

  _VerseTextState(
      {this.book,
      this.chapter,
      this.chapterText,
      this.scrollToVerseMethod,
      this.verseNumber});

  double _ratingIndicator = 0.0;
  bool checkValue;
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    getCredential();
  }

  getCredential() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _ratingIndicator = sharedPreferences.getDouble("font");
      // if (_ratingIndicator != null) {
      //     username.text = sharedPreferences.getString("username");
      //     password.text = sharedPreferences.getString("password");

      // } else {
      //   checkValue = false;
      // }
    });
  }

  Future<double> getValue(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double stringValue = prefs.getDouble(name);
    return stringValue;
  }

  @override
  Widget build(BuildContext context) {
    List<InlineSpan> versesText = List<InlineSpan>();
    // _ratingIndicator = getValue("font") ?? 13;
    for (IChapterElement verse in chapter.elements) {
      versesText.add(verse.toTextSpanWidget(context));
    }
    var expandedChapterText = versesText;

    if (!widget.showReferences) {
      expandedChapterText.removeWhere((span) => span is WidgetSpan);
    }
    //print("the fontsize${_ratingIndicator == null ? 13 : _ratingIndicator}");
    TextSpan chapterText = TextSpan(
      children: expandedChapterText,
      style: TextStyle(fontSize: widget.fontSize),
    );

    var width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text.rich(
          chapterText,
          style: TextStyle(fontSize: widget.fontSize),
        ),
      ),
    );
    //_ratingIndicator == null ? 13 : _ratingIndicator
    // return Container(
    //   width: width,
    //   child: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: SelectableText.rich(
    //       chapterText,
    //     ),
    //   ),
    // );
  }

  List<InlineSpan> _flattenTextSpans(List<InlineSpan> iterable) {
    return iterable.expand((InlineSpan e) => [e]).toList();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (scrollToVerseMethod != null) {
      scrollToVerseMethod();
    }
  }
}
