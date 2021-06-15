import 'package:flutter/material.dart';
import 'package:app/components/forgot_password/widget/forgot_password.dart';
import 'package:app/menu/default_layout.dart';

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Layout(
        backButton: true,
        title: "FORGOT PASSWORD",
        body: ForgotPassword(welcomeText: 'Forgot password. \nDon\'t worry.'));
  }
}
