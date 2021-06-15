import 'dart:async';
import 'dart:io' show Platform;
import 'package:app/Feature/Search/Views/SearchPage/BibleSearchDelegate.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:app/configs/colors.dart';
// import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:app/Feature/InheritedBlocs.dart';
import 'package:app/Feature/Navigation/navigation_feature.dart';
import 'package:app/Feature/Reader/reader_feature.dart';
import 'package:app/Foundation/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReaderPage extends StatefulWidget {
  final bibleBloc;
  // ReaderPage(this.bibleBloc);
  const ReaderPage({Key key, this.bibleBloc}) : super(key: key);

  @override
  _ReaderPageState createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  ScrollController controller = ScrollController();
  bool hasScrolled;
  IconData icon = Icons.play_arrow;
  // String _newVoiceText;
  List<IChapterElement> elements;
  List<InlineSpan> versesText = List<InlineSpan>();
  FlutterTts flutterTts;

  /// Allowed values are in the range from 0.0 (silent) to 1.0 (loudest)
  double volume = 1;

  /// 1.0 is default and ranges from .5 to 2.0
  double pitch = 1.0;

  /// Allowed values are in the range from 0.0 (slowest) to 1.0 (fastest)
  double rate = 0.5;

  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  bool bolSpeaking = false;
  bool isCurrentLanguageInstalled = false;

  String _newVoiceText;
  double _fontSize = 12.0;
  double _ratingIndicator = 0.0;
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    //controller.addListener(_scrollToVerse);
    hasScrolled = false;
    super.initState();
    initTts();
    getCredential();
  }

  initTts() {
    flutterTts = FlutterTts();
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  getCredential() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _fontSize = sharedPreferences.getDouble("font");
      // if (_ratingIndicator != null) {
      //     username.text = sharedPreferences.getString("username");
      //     password.text = sharedPreferences.getString("password");

      // } else {
      //   checkValue = false;
      // }
    });
  }

  List<InlineSpan> _flattenTextSpans(List<InlineSpan> iterable) {
    print("testt${iterable.expand((InlineSpan e) => [e]).toString()}");
    return iterable.expand((InlineSpan e) => [e]).toList();
  }

  void _showFontSizePickerDialog() async {
    // <-- note the async keyword here

    // this will contain the result from Navigator.pop(context, result)
    final selectedFontSize = await showDialog<double>(
      context: context,
      builder: (context) => FontSizePickerDialog(initialFontSize: _fontSize),
    );
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    // execution of this code continues when the dialog was closed (popped)

    // note that the result can also be null, so check it
    // (back button or pressed outside of the dialog)
    if (selectedFontSize != null) {
      setState(() {
        _fontSize = selectedFontSize;

        localStorage.setDouble('font', _fontSize);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back, color: Colors.black),
      //     onPressed: () => Navigator.of(context).pop(),
      //   ),
      // ),
      // appBar: AppBar(

      // ),

      floatingActionButton: !isAndroid
          ? FloatingActionButton(
              tooltip: "Bible Verses",
              onPressed: () {
                if (bolSpeaking == false) {
                  if (!elements.isEmpty) {
                    for (IChapterElement verse in elements) {
                      versesText.add(verse.toTextSpanWidget(context));
                    }
                    var expandedChapterText = _flattenTextSpans(versesText);

                    for (var verseText in expandedChapterText) {
                      _newVoiceText = verseText.toPlainText().toString();
                      speakText(_newVoiceText);
                      // playTtsString1();
                    }
                    bolSpeaking = true;
                    // _speak;

                  }
                } else if (bolSpeaking == true) {
                  bolSpeaking = false;
                  _newVoiceText = "";
                  stop();
                }
                // Add your onPressed code here!
                setState(() {
                  icon = bolSpeaking == true ? Icons.stop : Icons.play_arrow; // Change icon and setState to rebuild
                });
              },
              child: new Icon(icon, size: 25.0),
              heroTag: null,
              backgroundColor: Colors.blue[900],
            )
          : null,

      body: StreamBuilder(
        stream: InheritedBlocs.of(context).bibleBloc.previousChapter,
        builder: (_, prevChapter) => StreamBuilder(
          stream: InheritedBlocs.of(context).bibleBloc.nextChapter,
          builder: (_, nextChapter) {
            return StreamBuilder<ChapterReference>(
              stream: InheritedBlocs.of(context).bibleBloc.chapterReference,
              builder: (context, AsyncSnapshot<ChapterReference> chapterReference) {
                if (chapterReference.hasData && prevChapter.hasData && nextChapter.hasData) {
                  elements = chapterReference.data.chapter.elements;
                  return CustomScrollView(
                    controller: controller,
                    slivers: <Widget>[
                      BibleReaderAppBar(
                        title: "${chapterReference.data.chapter.book.name} ${chapterReference.data.chapter.number}",
                        actions: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.settings,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              // do something
                              _showFontSizePickerDialog();
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () => showSearch(
                              context: context,
                              delegate: BibleSearchDelegate(),
                            ),
                          )
                        ],
                      ),
                      SliverToBoxAdapter(
                        child: Reader(
                          nextChapter: nextChapter.data,
                          previousChapter: prevChapter.data,
                          chapterReference: chapterReference.data,
                          controller: controller,
                          showReferences: true,
                          fontSize: _fontSize,
                        ),
                      ),
                    ],
                  );
                } else {
                  return CustomScrollView(
                    controller: controller,
                    slivers: <Widget>[
                      BibleReaderAppBar(
                        title: "Loading...",
                      ),
                      SliverToBoxAdapter(
                        child: LoadingColumn(),
                      ),
                    ],
                  );
                }
              },
              initialData: null,
            );
          },
          initialData: null,
        ),
        initialData: null,
      ),
      bottomNavigationBar: BibleBottomNavigationBar(context: context),
      // bottomNavigationBar: FFNavigationBar(
      //   theme: FFNavigationBarTheme(
      //     barBackgroundColor: Colors.white,
      //     selectedItemBorderColor: Colors.yellow,
      //     selectedItemBackgroundColor: Colors.green,
      //     selectedItemIconColor: Colors.white,
      //     selectedItemLabelColor: Colors.black,
      //   ),
      //   // var  selectedIndex: selectedIndex,
      //   onSelectTab: (index) {
      //     setState(() {
      //       // selectedIndex = index;
      //     });
      //   },
      //   items: [
      //     FFNavigationBarItem(
      //       iconData: Icons.home,
      //       label: 'Home',
      //     ),
      //     FFNavigationBarItem(
      //       iconData: Icons.library_books,
      //       label: 'Bible',
      //     ),
      //     FFNavigationBarItem(
      //       iconData: Icons.attach_money,
      //       label: 'Anchor',
      //     ),
      //     FFNavigationBarItem(
      //       iconData: Icons.note,
      //       label: 'Notes',
      //     ),
      //     FFNavigationBarItem(
      //       iconData: Icons.settings,
      //       label: 'Settings',
      //     ),
      //   ],
      // ),
    );
  }

  Future speakText(String text) async {
    stop();
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak(text);
  }

  /// stop existing speech
  Future stop() async {
    await flutterTts.stop();
  }
}

class FontSizePickerDialog extends StatefulWidget {
  /// initial selection for the slider
  final double initialFontSize;

  const FontSizePickerDialog({Key key, this.initialFontSize}) : super(key: key);

  @override
  _FontSizePickerDialogState createState() => _FontSizePickerDialogState();
}

class _FontSizePickerDialogState extends State<FontSizePickerDialog> {
  /// current selection of the slider
  double _fontSize;

  @override
  void initState() {
    super.initState();
    _fontSize = widget.initialFontSize;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Bible Font Size'),
      content: Container(
        child: Slider(
          value: _fontSize ?? 12,
          min: 5,
          max: 30,
          divisions: 5,
          onChanged: (value) {
            setState(() {
              _fontSize = value;
            });
          },
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            // Use the second argument of Navigator.pop(...) to pass
            // back a result to the page that opened the dialog
            Navigator.pop(context, _fontSize);
          },
          child: Text('DONE'),
        )
      ],
    );
  }
}
