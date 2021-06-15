import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String pageName;

  WebViewPage(this.url, this.pageName);

  @override
  State<StatefulWidget> createState() {
    return new _WebViewPage();
  }
}

class _WebViewPage extends State<WebViewPage> {
  // final flutterWebviewPlugin = new FlutterWebviewPlugin();
  String username = '';
  String password = '';
  var options = InAppBrowserClassOptions(
      crossPlatform: InAppBrowserOptions(hideUrlBar: true),
      inAppWebViewGroupOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(javaScriptEnabled: true)));

  @override
  void initState() {
    super.initState();
    _simulateLoad();
  }

  Future _simulateLoad() async {
    //Future.delayed(Duration(seconds: 5), () {
    //  setState(() async {
    username = await getValue('email') ?? "";
    password = await getValue('password') ?? "";
    //  flutterWebviewPlugin.close();
    // });
    // });

    WidgetsFlutterBinding.ensureInitialized();

    if (Platform.isAndroid) {
      await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    }
  }

  @override
  void dispose() {
    // flutterWebviewPlugin.dispose();
    super.dispose();
  }

  getValue(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString(name);
    return stringValue;
  }

  @override
  Future onBrowserCreated() async {
    print("Browser Created!");
  }

  @override
  Future onLoadStart(url) async {
    print("Started $url");
  }

  @override
  Future onLoadStop(url) async {
    print("Stopped $url");
  }

  @override
  void onLoadError(url, code, message) {
    print("Can't load $url.. Error: $message");
  }

  @override
  void onProgressChanged(progress) {
    print("Progress: $progress");
  }

  @override
  void onExit() {
    print("Browser closed!");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white, //Color.fromRGBO(58, 66, 86, 1.0),
      appBar: new AppBar(
        title: new Text(widget.pageName),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        elevation: 0.0,
      ),
      body: InAppWebView(
        // appBar: new AppBar(
        //   title: new Text(widget.pageName),
        //   centerTitle: true,
        //   backgroundColor: Colors.blue[900],
        //   elevation: 0.0,
        // ),

        initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
        // withJavascript: true,
        // headers: {
        //   'Authorization':
        //       'Basic ' + base64Encode(utf8.encode('$username:$password'))
        // },
        onReceivedServerTrustAuthRequest: (controller, challenge) async {
          print(challenge);
          return ServerTrustAuthResponse(
              action: ServerTrustAuthResponseAction.PROCEED);
        },
      ),
    );
  }
}
