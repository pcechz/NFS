import 'package:flutter/material.dart';
import 'package:app/components/login/widget/login.dart';
import 'package:app/menu/default_layout.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Layout(
        backButton: false,
        title: "LOGIN",
        appBar: false,
        body: Login(welcomeText: 'Hello there, \nwelcome.'));
  }
}
