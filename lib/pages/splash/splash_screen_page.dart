import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/components/splash/repository/splash_repository.dart';
import 'package:app/routers/routes.dart';
import 'package:app/settings/Settings.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  bool isAuth = false;

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
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
    openHomePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SplashRepository().loadWidget());
  }

  void openHomePage() {
    Timer(
        Duration(seconds: Settings.splashScreenDuration),
        () => {
              if (isAuth)
                {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Rout.home))
                }
              else
                {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Rout.login))
                }
            });
  }
}
