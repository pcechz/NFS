import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:app/components/common/button/form_button.dart';
import 'package:app/components/common/input_field/custom_input_field.dart';
import 'package:app/components/common/separator/separator.dart';
import 'package:app/components/common/style/styles.dart';
import 'package:app/components/common/validator/validators.dart';
import 'package:app/network_utils/api.dart';
import 'package:app/routers/routes.dart';
import 'package:app/settings/Settings.dart';

class Register extends StatefulWidget {
  final welcomeText;

  Register({this.welcomeText});

  @override
  RegisterState createState() {
    return RegisterState();
  }
}

class RegisterState extends State<Register> {
  /// title and welcome text are set here
//  final String title = "REGISTER";
//  final String welcomeText = 'Welcome, \nsign up now.';

  //  _formKey and _autoValidate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _name;
  String _email;
  String _password;
  String _phone;
  bool _isLoading = false;
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'NG';
  PhoneNumber number = PhoneNumber(isoCode: 'NG');
  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    // _scaffoldKey.currentState.showSnackBar(snackBar);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 5.0),
              child: Text(this.widget.welcomeText,
                  style: TextStyle(
                      color: Styles.helperTextColor,
                      fontSize: Styles.h1,
                      fontWeight: Styles.lightFont)),
            ),
            Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: Column(
                children: <Widget>[
                  ///USERNAME INPUT
                  CustomInputField(
                    hintText: 'FullName',
                    validator: Validators.generalValidate,
                    onSaved: (String val) {
                      _name = val;
                      print(_name);
                    },
                    inputType: TextInputType.text,
                    margin: EdgeInsets.only(top: 28.0),
                  ),

                  /// EMAIL INPUT
                  CustomInputField(
                    hintText: 'Email',
                    validator: Validators.validateEmail,
                    onSaved: (String val) {
                      _email = val;
                      print(_email);
                    },
                    inputType: TextInputType.emailAddress,
                    margin: EdgeInsets.only(top: 28.0),
                  ),

                  /// PASSWORD INPUT
                  CustomInputField(
                    obscureText: true,
                    hintText: 'Password',
                    validator: Validators.generalValidate,
                    onSaved: (String val) {
                      _password = val;
                      print(_password);
                    },
                    inputType: null,
                    margin: EdgeInsets.only(top: 28.0),
                  ),
                  CustomInputField(
                    hintText: 'Phone',
                    validator: Validators.phoneNumberValidator,
                    onSaved: (String val) {
                      _phone = val;
                      print(_phone);
                    },
                    inputType: TextInputType.emailAddress,
                    margin: EdgeInsets.only(top: 28.0),
                  ),
                  Separator(height: 50.0),

                  /// SIGN UP BUTTON
                  FormButton(
                    text: "SIGN UP",
                    onTap: _validateInputs,
                  ),
                  Separator(height: 20.0),
                  Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("ALREADY HAVE AN ACCOUNT? ",
                          style: TextStyle(
                              color: Styles.helperTextColor,
                              fontSize: Styles.h5,
                              fontWeight: Styles.lightFont)),
                      InkWell(
                        child: Container(
                            height: 40.0,
                            child: Center(
                              child: Text("LOG IN!",
                                  style: TextStyle(
                                      color: Styles.helperTextColor,
                                      fontWeight: Styles.mediumFont,
                                      fontSize: Styles.h5)),
                            )),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Rout.login),
                          );
                        },
                      ),
                    ],
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _login();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      'email': _email,
      'password': _password,
      'name': _name,
      'phone': _phone
    };

    var res = await Network().authData(data, '/register');
    var body = json.decode(res.body);
    if (body['success']) {
      _showMsg("Signup Successful. Please login now.");
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => Rout.login),
      );
    } else {
      //print("jh" + body['message']);
      String error = "";

      final data = body['data'] as Map;
      for (final name in data.keys) {
        final value = data[name];
        print(value[0].toString());
        print('$name,$value'); // prints entries like "AED,3.672940"
        error = error + "\n " + value[0].toString();
      }
      _showMsg(body['message'] + error);
    }

    setState(() {
      _isLoading = false;
    });
  }
}
