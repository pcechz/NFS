// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:app/routers/routes.dart';
// import 'package:app/settings/Settings.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'localisation/AppLocalisations.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     return MaterialApp(
//       localizationsDelegates: [
//         AppLocalisations.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//       ],
//       supportedLocales: [
//         Locale("ar", "AE"),
//         Locale("en", "US"),
//       ],
//       locale: !Settings.rtl ? Locale("en", "US") : Locale("ar", "AE"),
//       theme: ThemeData(
//           unselectedWidgetColor: Color(0xffD0D0D0),
//           dividerColor: Colors.transparent,
//           fontFamily: 'TitilliumWeb'),
//       home: CheckAuth(),
//     );
//   }
// }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {

// //     return MaterialApp(
// //       localizationsDelegates: [
// //         AppLocalisations.delegate,
// //         GlobalMaterialLocalizations.delegate,
// //         GlobalWidgetsLocalizations.delegate,
// //       ],
// //       supportedLocales: [
// //         Locale("ar", "AE"),
// //         Locale("en", "US"),
// //       ],
// //       locale: !Settings.rtl ? Locale("en", "US") : Locale("ar", "AE"),
// //       theme: ThemeData(
// //           unselectedWidgetColor: Color(0xffD0D0D0),
// //           dividerColor: Colors.transparent,
// //           fontFamily: 'TitilliumWeb'),
// //       home: Rout.splashScreenPage,
// //     );
// //   }
// // }

import 'dart:convert';
import 'dart:io';

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
import 'package:app/pages/details/parallax_page.dart';
import 'package:app/pages/dialogs/notification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:app/routers/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/src/service/push_fcm_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
//import 'package:crashlytics/crashlytics.dart';
import 'package:http/http.dart' as http;

import 'Project/Pages/HistoryPage.dart';
import 'models/Anchors.dart';

void main() {
  // Crashlytics.setup();
  WidgetsFlutterBinding.ensureInitialized();
  GlobalConfiguration().loadFromAsset("app_settings");
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   GlobalConfiguration().loadFromAsset("app_settings");
//   final bibleBloc = BibleBloc(MultiPartXmlBibleProvider(), ReferenceProvider());
//   runApp(MyApp(
//     bibleBloc: bibleBloc,
//     settingsBloc: SettingsBloc(),
//   ));
// }

class MyApp extends StatelessWidget {
  // final bibleBloc;
  // final settingsBloc;

  // MyApp({this.bibleBloc, this.settingsBloc});

  // // This widget is the root of your application.
  static final navigatorKey = new GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'NIFES',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue[900],
      // ),
      home: CheckAuth(),
    );

    // return InheritedBlocs(
    //   bibleBloc: bibleBloc,
    //   settingsBloc: settingsBloc,
    //   notesBloc: NotesBloc(),
    //   navigationBloc: NavigationBloc(),
    //   searchBloc: SearchBloc(XmlBibleProvider()),
    //   child: MaterialApp(home: CheckAuth()),
    // );
  }
}

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.bibleBloc}) : super(key: key);
//   final bibleBloc;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<AppPage>(
//       stream: InheritedBlocs.of(context).navigationBloc.currentPage,
//       builder: (context, currentPageSnapshot) {
//         switch (currentPageSnapshot.data) {
//           case AppPage.readerPage:
//             return ReaderPage();
//             break;

//           case AppPage.notesPage:
//             return NotesPage();
//             break;

//           case AppPage.historyPage:
//             return HistoryPage();
//             break;
//           default:
//             return ReaderPage();
//             break;
//         }
//       },
//       initialData: null,
//     );
//   }
// }

class CheckAuth extends StatefulWidget {
//  final bibleBloc;

  // CheckAuth({this.bibleBloc});
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  String _notificationMsg = 'No Message';
  String _debugLabelString = "";
  String _emailAddress;
  String _externalUserId;
  bool _enableConsentButton = false;
  String _platformVersion = 'Unknown';

  // CHANGE THIS parameter to true if you want to test GDPR privacy consent
  bool _requireConsent = true;
  // var type = "";
  // var uuid = "";

  bool isAuth = false;
//  final bibleBloc = BibleBloc(MultiPartXmlBibleProvider(), ReferenceProvider());
  @override
  void initState() {
    //_checkIfLoggedIn();
    super.initState();
    // _checkIfLoggedIn();
    initPlatformState();
    // FCM firebaseMessaging = FCM();
    // firebaseMessaging.setNotifications();
    // firebaseMessaging.streamCtlr.stream.listen((msgData) {
    //   _changeMsg(msgData);
    // });
  }

  @override
  void dispose() {
    // OneSignal.shared.
    super.dispose();
  }

  List<Anchors> _anchors = List<Anchors>();
  _changeMsg(String msg) {
    setState(() {
      _notificationMsg = msg;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initPlatformState() async {
  //   String platformVersion;

  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;

  //   setState(() {
  //     _platformVersion = platformVersion;
  //   });
  // }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // String platformVersion;

    if (!mounted) return;

    // setState(() {
    //   _platformVersion = platformVersion;
    // });

    OneSignal.shared.setAppId("8ad02ec3-83f1-4c85-920f-a13fb09e34b2");
    // ("8ad02ec3-83f1-4c85-920f-a13fb09e34b2", iOSSettings: {OSiOSSettings.autoPrompt: false, OSiOSSettings.inAppLaunchUrl: false});
    //Remove this method to stop OneSignal Debugging
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    // OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);

    // OneSignal.shared.setNotificationReceivedHandler((OSNotification notification) {
    // will be called whenever a notification is received
    // print("clickedd2${notification.payload.additionalData}");
    // var body = notification.payload.additionalData;
    // var type = body["type"];
    // var uuid = body["uuid"];
    // print("clickedd3${uuid}");
    // print("clickedd1${type}");
    // });

    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // will be called whenever a notification is opened/button pressed.

      print("clickedd${result.notification.additionalData}");
      var body = result.notification.additionalData;
      var type = body["type"].toString();
      var uuid = body["uuid"].toString();
      print("clickedd3$uuid");
      print("clickedd1$type");

      if (type != null && uuid != null) {
        try {
          MyApp.navigatorKey.currentState.push(MaterialPageRoute(builder: (context) => NotificationDialog(uuid: uuid, type: type)));
        } catch (e) {
          print(e.toString());
        }
      }
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // will be called whenever the permission changes
      // (ie. user taps Allow on the permission prompt in iOS)
    });

    OneSignal.shared.setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      // will be called whenever the subscription changes
      //(ie. user gets registered with OneSignal and gets a user ID)
    });

    OneSignal.shared.setEmailSubscriptionObserver((OSEmailSubscriptionStateChanges emailChanges) {
      // will be called whenever then user's email subscription changes
      // (ie. OneSignal.setEmail(email) is called and the user gets registered
    });

    OneSignal.shared.promptUserForPushNotificationPermission();

// If you want to know if the user allowed/denied permission,
// the function returns a Future<bool>:
    bool allowed = await OneSignal.shared.promptUserForPushNotificationPermission();
  }

  void _handleGetTags() {
    OneSignal.shared.getTags().then((tags) {
      if (tags == null) return;

      setState((() {
        _debugLabelString = "$tags";
      }));
    }).catchError((error) {
      setState(() {
        _debugLabelString = "$error";
      });
    });
  }

  void _handleSendTags() {
    print("Sending tags");
    OneSignal.shared.sendTag("test2", "val2").then((response) {
      print("Successfully sent tags with response: $response");
    }).catchError((error) {
      print("Encountered an error sending tags: $error");
    });
  }

  void _handlePromptForPushPermission() {
    print("Prompting for Permission");
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });
  }

  void _handleGetPermissionSubscriptionState() {
    print("Getting permissionSubscriptionState");
    // OneSignal.shared.getPermissionSubscriptionState().then((status) {
    //   this.setState(() {
    //     _debugLabelString = status.jsonRepresentation();
    //   });
    // });
  }

  void _handleSetEmail() {
    if (_emailAddress == null) return;

    print("Setting email");

    OneSignal.shared.setEmail(email: _emailAddress).whenComplete(() {
      print("Successfully set email");
    }).catchError((error) {
      print("Failed to set email with error: $error");
    });
  }

  void _handleLogoutEmail() {
    print("Logging out of email");
    OneSignal.shared.logoutEmail().then((v) {
      print("Successfully logged out of email");
    }).catchError((error) {
      print("Failed to log out of email: $error");
    });
  }

  void _handleConsent() {
    print("Setting consent to true");
    OneSignal.shared.consentGranted(true);

    print("Setting state");
    this.setState(() {
      _enableConsentButton = false;
    });
  }

  void _handleSetLocationShared() {
    print("Setting location shared to true");
    OneSignal.shared.setLocationShared(true);
  }

  void _handleDeleteTag() {
    print("Deleting tag");
    OneSignal.shared.deleteTag("test2").then((response) {
      print("Successfully deleted tags with response $response");
    }).catchError((error) {
      print("Encountered error deleting tag: $error");
    });
  }

  void _handleSetExternalUserId() {
    print("Setting external user ID");
    OneSignal.shared.setExternalUserId(_externalUserId).then((results) {
      if (results == null) return;

      this.setState(() {
        _debugLabelString = "External user id set: $results";
      });
    });
  }

  void _handleRemoveExternalUserId() {
    OneSignal.shared.removeExternalUserId().then((results) {
      if (results == null) return;

      this.setState(() {
        _debugLabelString = "External user id removed: $results";
      });
    });
  }

  void _handleSendNotification() async {
    // var status = await OneSignal.shared.getPermissionSubscriptionState();

    // var playerId = status.subscriptionStatus.userId;

    // var imgUrlString = "http://cdn1-www.dogtime.com/assets/uploads/gallery/30-impossibly-cute-puppies/impossibly-cute-puppy-2.jpg";

    // var notification =
    //     OSCreateNotification(playerIds: [playerId], content: "this is a test from OneSignal's Flutter SDK", heading: "Test Notification", iosAttachments: {"id1": imgUrlString}, bigPicture: imgUrlString, buttons: [OSActionButton(text: "test1", id: "id1"), OSActionButton(text: "test2", id: "id2")]);

    // var response = await OneSignal.shared.postNotification(notification);

    // this.setState(() {
    //   _debugLabelString = "Sent notification with response: $response";
    // });
  }

  void _handleSendSilentNotification() async {
    // var status = await OneSignal.shared.getPermissionSubscriptionState();

    // var playerId = status.subscriptionStatus.userId;

    // var notification = OSCreateNotification.silentNotification(playerIds: [playerId], additionalData: {'test': 'value'});

    // var response = await OneSignal.shared.postNotification(notification);

    // this.setState(() {
    //   _debugLabelString = "Sent notification with response: $response";
    // });
  }

  oneSignalInAppMessagingTriggerExamples() async {
    /// Example addTrigger call for IAM
    /// This will add 1 trigger so if there are any IAM satisfying it, it
    /// will be shown to the user
    OneSignal.shared.addTrigger("trigger_1", "one");

    /// Example addTriggers call for IAM
    /// This will add 2 triggers so if there are any IAM satisfying these, they
    /// will be shown to the user
    Map<String, Object> triggers = new Map<String, Object>();
    triggers["trigger_2"] = "two";
    triggers["trigger_3"] = "three";
    OneSignal.shared.addTriggers(triggers);

    // Removes a trigger by its key so if any future IAM are pulled with
    // these triggers they will not be shown until the trigger is added back
    OneSignal.shared.removeTriggerForKey("trigger_2");

    // Get the value for a trigger by its key
    Object triggerValue = await OneSignal.shared.getTriggerValueForKey("trigger_3");
    print("'trigger_3' key trigger value: " + triggerValue.toString());

    // Create a list and bulk remove triggers based on keys supplied
    List<String> keys = ["trigger_1", "trigger_3"];
    OneSignal.shared.removeTriggersForKeys(keys);

    // Toggle pausing (displaying or not) of IAMs
    OneSignal.shared.pauseInAppMessages(false);
  }

  oneSignalOutcomeEventsExamples() async {
    // Await example for sending outcomes
    outcomeAwaitExample();

    // Send a normal outcome and get a reply with the name of the outcome
    OneSignal.shared.sendOutcome("normal_1");
    OneSignal.shared.sendOutcome("normal_2").then((outcomeEvent) {
      print(outcomeEvent.jsonRepresentation());
    });

    // Send a unique outcome and get a reply with the name of the outcome
    OneSignal.shared.sendUniqueOutcome("unique_1");
    OneSignal.shared.sendUniqueOutcome("unique_2").then((outcomeEvent) {
      print(outcomeEvent.jsonRepresentation());
    });

    // Send an outcome with a value and get a reply with the name of the outcome
    OneSignal.shared.sendOutcomeWithValue("value_1", 3.2);
    OneSignal.shared.sendOutcomeWithValue("value_2", 3.9).then((outcomeEvent) {
      print(outcomeEvent.jsonRepresentation());
    });
  }

  Future<void> outcomeAwaitExample() async {
    var outcomeEvent = await OneSignal.shared.sendOutcome("await_normal_1");
    print(outcomeEvent.jsonRepresentation());
  }

  void _checkIfLoggedIn() async {
    //WidgetsFlutterBinding.ensureInitialized();

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (token != null) {
      setState(() {
        isAuth = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    // if (isAuth) {
    child = Rout.splashScreenPage;
    // } else {
    //   child = Rout.login;
    // }
    return Scaffold(
      body: child,
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

// class GlobalVariable {
//   /// This global key is used in material app for navigation through firebase notifications.
//   /// [navState] usage can be found in [notification_notifier.dart] file.
//   static final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
// }
