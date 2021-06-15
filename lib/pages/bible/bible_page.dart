import 'package:app/Feature/InheritedBlocs.dart';
import 'package:app/Feature/Navigation/navigation_feature.dart';
import 'package:app/Feature/Notes/notes_feature.dart';
import 'package:app/Feature/Reader/reader_feature.dart';
import 'package:app/Feature/Search/search_feature.dart';
import 'package:app/Feature/Settings/settings_feature.dart';
import 'package:app/Foundation/Provider/ReferenceProvider.dart';
import 'package:app/Foundation/foundation.dart';
import 'package:app/Project/Designs/DarkDesign.dart';
import 'package:app/Project/Pages/NotesPage.dart';
import 'package:app/Project/Pages/ReaderPage.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

import '../../Project/Pages/HistoryPage.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await GlobalConfiguration().loadFromAsset("app_settings");
//   final bibleBloc = BibleBloc(MultiPartXmlBibleProvider(), ReferenceProvider());
//   runApp(MyApp(
//     bibleBloc: bibleBloc,
//     settingsBloc: SettingsBloc(),
//   ));
// }

class BiblePage extends StatelessWidget {
  var bibleBloc = BibleBloc(MultiPartXmlBibleProvider(), ReferenceProvider());

  var settingsBloc = SettingsBloc();

  //final settingsBloc;

  BiblePage({this.bibleBloc, this.settingsBloc});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // GlobalConfiguration cfg = new GlobalConfiguration();
    // cfg.loadFromAsset("app_settings");
    return InheritedBlocs(
      bibleBloc: BibleBloc(MultiPartXmlBibleProvider(), ReferenceProvider()),
      settingsBloc: SettingsBloc(),
      notesBloc: NotesBloc(),
      navigationBloc: NavigationBloc(),
      searchBloc: SearchBloc(XmlBibleProvider()),
      child: MaterialApp(
        // theme: Designs.darkTheme,
        home: MyBiblePage(
          bibleBloc:
              BibleBloc(MultiPartXmlBibleProvider(), ReferenceProvider()),
        ),
      ),
    );
  }
}

class MyBiblePage extends StatefulWidget {
  MyBiblePage({Key key, this.bibleBloc}) : super(key: key);
  final bibleBloc;

  @override
  _MyBiblePageState createState() => _MyBiblePageState();
}

class _MyBiblePageState extends State<MyBiblePage> {
  @override
  void initState() {
    super.initState();
    // _loadConfig();
    print("heeee");
    // GlobalConfiguration().loadFromAsset("app_settings");
  }

  // Future<void> _loadConfig() async {
  //   await GlobalConfiguration().loadFromAsset("app_settings");
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppPage>(
      stream: InheritedBlocs.of(context).navigationBloc.currentPage,
      builder: (context, currentPageSnapshot) {
        switch (currentPageSnapshot.data) {
          case AppPage.readerPage:
            return ReaderPage();
            break;

          case AppPage.notesPage:
            return NotesPage();
            break;

          case AppPage.historyPage:
            return HistoryPage();
            break;
          default:
            return ReaderPage();
            break;
        }
      },
      initialData: null,
    );
  }
}
